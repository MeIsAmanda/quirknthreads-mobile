import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../main.dart';
import '../state/cart/cart_bloc.dart';
import '../widgets/cart_item_card.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cart = context.watch<CartBloc>().state.cart;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Cart', style: textTheme.headlineSmall),
        actions: [
          Badge(
            isLabelVisible: cart.cartItems.isNotEmpty,
            label: Text('${cart.totalQuantity}'),
            child: const Icon(Icons.shopping_cart),
          ),
          const SizedBox(width: 16.0),
        ],
      ),
      body: BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
    if (state.status == CartStatus.loading ||
        state.status == CartStatus.initial) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.status == CartStatus.loaded &&
        state.cart.cartItems.isEmpty){
      return const Center(child: Text('No items in the cart'));
    }
    if (state.status == CartStatus.loaded){
    return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${cart.totalQuantity} Items in the Cart',
                style: textTheme.headlineSmall,
              ),
              const SizedBox(height: 16.0),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cart.cartItems.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final cartItem = cart.cartItems[index];
                  return CartItemCard(cartItem: cartItem);
                },
              ),
            ],
          ),
        ),
      );
    } else {
      return const Center(child: Text('Something went wrong!'));
    }
  },
),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Expanded(child: Text('Total: \$${cart.totalPrice}')),
            const SizedBox(width: 16.0),
            Expanded(
              child: FilledButton(
                onPressed: () {
                  // Navigator.pushNamed(context, '/checkout');
                  context.pushNamed('checkout');
                },
                child: const Text('Pay Now'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
