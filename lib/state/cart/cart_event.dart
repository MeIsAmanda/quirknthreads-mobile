part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable{
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class LoadCartEvent extends CartEvent {
  final String? userId;
  const LoadCartEvent({this.userId});

  @override
  List<Object?> get props => [userId];
}

class AddToCartEvent extends CartEvent {
  final Product product;
  const AddToCartEvent({required this.product});

  @override
  List<Object?> get props => [product];
}

class RemoveFromCart extends CartEvent {
  final Product product;
  const RemoveFromCart({required this.product});

  @override
  List<Object?> get props => [product];
}

class ClearCartAndUser extends CartEvent {
  @override
  List<Object?> get props => [];
}
