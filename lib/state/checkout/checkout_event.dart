part of 'checkout_bloc.dart';

class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object> get props => [];

}

class LoadCheckoutEvent extends CheckoutEvent {
  final String userId;
  final Cart cart;
  const LoadCheckoutEvent({
    required this.userId,
    required this.cart,
  });

  @override
  List<Object> get props => [userId, cart];

}

class UpdateCardCompleteStatus extends CheckoutEvent {
  final bool cardComplete;

  const UpdateCardCompleteStatus({required this.cardComplete});

  @override
  List<Object> get props => [cardComplete];
}

class StartCheckoutEvent extends CheckoutEvent{}

class ConfirmCheckoutEvent extends CheckoutEvent{}