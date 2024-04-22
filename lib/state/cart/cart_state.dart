part of 'cart_bloc.dart';

enum CartStatus {initial, loading, loaded, error}

class CartState extends Equatable{
  final CartStatus status;
  final Cart cart;

  const CartState({
    this.status = CartStatus.initial,
    this.cart = const Cart(userId: '', cartItems: []),
});

  CartState copyWith({
    CartStatus? status,
    Cart? cart,
}) {
    return CartState(
      status: status ?? this.status,
      cart: cart ?? this.cart,
    );
  }

  @override
  List<Object> get props => [];
}

final class CartInitial extends CartState {}
