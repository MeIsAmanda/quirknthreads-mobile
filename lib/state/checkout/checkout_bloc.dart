import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/cart.dart';
import '../../models/order_status.dart';
import '../../repositories/order_repository.dart';
import '../../repositories/checkout_repository.dart';


part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final OrderRepository _orderRepository;
  final CheckoutRepository _checkoutRepository;

  CheckoutBloc({
    required OrderRepository orderRepository,
    required CheckoutRepository checkoutRepository,
}) : _orderRepository = orderRepository,
        _checkoutRepository = checkoutRepository,
        super(const CheckoutState()) {
    on<LoadCheckoutEvent>(_onLoadCheckout);
    on<UpdateCardCompleteStatus>(_onUpdateCardCompleteStatus);
    on<StartCheckoutEvent>(_onStartCheckout);
    on<ConfirmCheckoutEvent>(_onConfirmCheckout);

  }

  _onLoadCheckout(
      LoadCheckoutEvent event,
      Emitter<CheckoutState> emit,
      ) {
    emit(state.copyWith(status: CheckoutStatus.loading));
    try {
      emit(
        state.copyWith(
          status: CheckoutStatus.loaded,
          cart: event.cart,
        ),
      );
    } catch (err) {
      emit(state.copyWith(status: CheckoutStatus.error));
    }
  }

  _onUpdateCardCompleteStatus(
      UpdateCardCompleteStatus event,
      Emitter<CheckoutState> emit,
      ) {
    emit(state.copyWith(cardComplete: event.cardComplete));
  }

  _onStartCheckout(
      StartCheckoutEvent event,
      Emitter<CheckoutState> emit,
    ) async {
    emit(state.copyWith(paymentStatus: PaymentStatus.loading));

    try {
      final paymentMethod = await _checkoutRepository.createPaymentMethod();

      final total = state.cart?.totalPrice ?? 0.0;
      final items = state.cart?.cartItems.map((e) => e.toJson()).toList() ?? [];

      final response = await _checkoutRepository.processPayment(
        paymentMethodId: paymentMethod.id,
        items: items,
      );

      if (response['status'] == OrderStatus.processing) {
        await _orderRepository.createOrder(
          userId: state.cart?.userId ?? '',
          items: items,
          total: total,
        );
      emit(state.copyWith(paymentStatus:
      PaymentStatus.success,
        paymentMessage: response['message'],
      ),
    );
      return;
    } else if (response['status'] == OrderStatus.waitingForPaymentConfirmation){
        emit(state.copyWith(
          paymentStatus: PaymentStatus.confirmationRequired,
          paymentMessage: response['message'],
          paymentClientSecret: response['clientSecret'],
        ),);
        add(ConfirmCheckoutEvent());
        return;
    }
      // fallback scenario
      emit(state.copyWith(
        paymentStatus: PaymentStatus.error,
        paymentMessage: response['message'],
        ),
      );

    } catch (err) {
      emit(state.copyWith(
        paymentStatus: PaymentStatus.error,
        paymentMessage: err.toString(),
      ),
      );
    }

  }


  _onConfirmCheckout(
    ConfirmCheckoutEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(state.copyWith(
      paymentStatus: PaymentStatus.loading,
    ));

    try{
      final response = await _checkoutRepository.confirmPayment(
          clientSecret: state.paymentClientSecret ?? '');

      if (response['status'] == OrderStatus.processing) {
        final total = state.cart?.totalPrice ?? 0.0;
        final items = state.cart?.cartItems.map((e) => e.toJson()).toList() ?? [];

        await _orderRepository.createOrder(
          userId: state.cart?.userId ?? '',
          items: items,
          total: total,
        );

        emit(
          state.copyWith(
            paymentStatus: PaymentStatus.success,
            paymentMessage: response['message'],
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          paymentStatus: PaymentStatus.error,
          paymentMessage: response['message'],
        ),
      );

    } catch(err) {
      emit(
        state.copyWith(
          paymentStatus: PaymentStatus.error,
          paymentMessage: err.toString(),
        ),
      );
    }
  }

}
