import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

import '../../models/cart.dart';
import '../../models/cart_item.dart';
import '../../models/product.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<LoadCartEvent>(_onLoadCart);
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<ClearCartAndUser>(_onClearCart);
  }

  void _onLoadCart(LoadCartEvent event,
      Emitter<CartState> emit) {
    print("starting load cart");
    emit(state.copyWith(status: CartStatus.loading));
    try {
      emit(state.copyWith(
        status: CartStatus.loaded,
        cart: Cart(
            userId: event.userId ?? '',
            cartItems: [],
        ),
      ),);
      print("afterload");
      print(state.status);
  } catch (err) {
      emit(state.copyWith(status: CartStatus.loading));
      print(err);
    }
  }

  void _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) {
    emit(state.copyWith(status: CartStatus.loading));

    try{
      print("_onAddToCart");
      var cart = state.cart;
      print(cart);
      print(event.product.id);
      var existingCartItem = cart.cartItems
          .where((item) => item.product.id == event.product.id)
          .firstOrNull;

      if (existingCartItem != null) {
        print("already exist");
        // Modify the quantity
        final index = cart.cartItems.indexOf(existingCartItem);
        final initialQuantity = existingCartItem.quantity;

        cart = cart.copyWith(
          cartItems: List.from(cart.cartItems)
            ..removeAt(index)
            ..insert(index, existingCartItem.copyWith(quantity: initialQuantity + 1),
            ),
        );
        emit(state.copyWith(status: CartStatus.loaded, cart:cart));
      } else {
        // Add the product to cart
        print("adding to cart");
        cart = cart.copyWith(
          cartItems: List.from(cart.cartItems)
            ..add(
              CartItem(
                  id: const Uuid().v4(),
                  product: event.product,
                  quantity: 1
              ),
            ),
        );
        emit(state.copyWith(status: CartStatus.loaded, cart:cart));
        print("after adding");
        print(state.status);
        print(cart.cartItems);
        print(cart);
      }
    } catch (err) {
      emit(state.copyWith(status: CartStatus.error));
      print(err);
    }
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) {
    emit(state.copyWith(status: CartStatus.loading));

    try {
      var cart = state.cart;
      var existingCartItem = cart.cartItems
          .where((item) => item.product.id == event.product.id)
          .first;

      final initialQuantity = existingCartItem.quantity;
      final index = cart.cartItems.indexOf(existingCartItem);

      if (initialQuantity > 1) {
        cart = cart.copyWith(
          cartItems: List.from(cart.cartItems)
              ..removeAt(index)
              ..insert(
                index,
                existingCartItem.copyWith(quantity: initialQuantity - 1),
              ),
        );
        emit(state.copyWith(status: CartStatus.loaded, cart:cart));
      }

    } catch(err) {
      emit(state.copyWith(status: CartStatus.error));
    }


  }

  void _onClearCart(ClearCartAndUser event,
      Emitter<CartState> emit) {
    print("starting clear cart");
    emit(state.copyWith(status: CartStatus.loading));
    try {
      emit(state.copyWith(
        status: CartStatus.loaded,
        cart: const Cart(
          userId: '',
          cartItems: [],
        ),
      ),);
      print("afterload");
      print(state.status);
    } catch (err) {
      emit(state.copyWith(status: CartStatus.loading));
      print(err);
    }
  }


}
