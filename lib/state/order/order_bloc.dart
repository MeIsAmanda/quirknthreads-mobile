import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/category.dart';
import '../../models/order.dart';
import '../../models/product.dart';
import '../../repositories/category_repository.dart';
import '../../repositories/order_repository.dart';
import '../../repositories/product_repository.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository _orderRepository;
  final ProductRepository _productRepository;


  OrderBloc({
    required OrderRepository orderRepository,
    required ProductRepository productRepository,
  }) : _orderRepository = orderRepository,
        _productRepository = productRepository,
        super(const OrderState()) {
    on<LoadOrdersEvent>(_onLoadOrders);
  }

  _onLoadOrders(
      LoadOrdersEvent event,
      Emitter<OrderState> emit,
      ) async {
    emit(state.copyWith(status: OrderStatus.loading));
    print("loading orders in order_bloc.dart");
     if (event.userId == null) {
       print("userId is null in order_bloc");
       emit(state.copyWith(status: OrderStatus.error));
     }

    try {

      final orders = await _orderRepository.fetchOrders(event.userId);
      print("printing orders in order bloc");
      print(orders);
      emit(state.copyWith(
        status: OrderStatus.loaded,
        orders: orders,
      ));
    } catch (err) {
       print(err);
      emit(state.copyWith(status: OrderStatus.error));
    }

  }

}
