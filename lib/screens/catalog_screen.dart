import 'dart:async';

import 'package:quirknthreads/repositories/cart_repository.dart';
import 'package:quirknthreads/repositories/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../main.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../repositories/category_repository.dart';
import '../state/cart/cart_bloc.dart';
import '../state/catalog/catalog_bloc.dart';

class CatalogScreen extends StatelessWidget{
  const CatalogScreen({
    super.key,
    required this.categoryId,
  });
  
  final String categoryId;
  
  @override
  Widget build(BuildContext context){
    return BlocProvider(
        create: (context) => CatalogBloc(
            categoryRepository: context.read<CategoryRepository>(),
        productRepository: context.read<ProductRepository>())
          ..add(LoadCatalogEvent(categoryId: categoryId)),
        child: CatalogView(),
    );
  }
}

class CatalogView extends StatelessWidget {
  const CatalogView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    
    final cart = context.watch<CartBloc>().state.cart;
    final category = context.select((CatalogBloc bloc) => bloc.state.category);
    
    return Scaffold(
        appBar: AppBar(
          title: Text(category?.name ?? 'Catalog'),
          // Text(
          //   'Catalog',
          //   style: Theme.of(context).textTheme.headlineSmall,
          // ),
          actions: [
            IconButton(
              onPressed: () {
                // Navigator.pushNamed(context, '/cart');
                context.pushNamed('cart');
              },
              icon: Badge(
                isLabelVisible: cart.cartItems.isNotEmpty,
                label: Text('${cart.totalQuantity}'),
                child: const Icon(Icons.shopping_cart),
              ),
            )
          ],
        ),
        body: BlocBuilder<CatalogBloc, CatalogState>(
      builder: (context, state) {
        print("testing");
        print(state.products);
        if (state.status == CatalogStatus.loading || state.status == CatalogStatus.initial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == CatalogStatus.loaded && state.products.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child:
                      Image.network(state.category!.imageUrl,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      height: 200,
                      width: double.infinity,
                      color: Theme
                          .of(context)
                          .colorScheme
                          .onInverseSurface
                          .withAlpha(100),
                    ),
                    Text(state.category!.name,
                      style: Theme
                          .of(context)
                          .textTheme
                          .headlineLarge!
                          .copyWith(color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 32.0),
                Text('No Products in this category',
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyLarge
                ),
              ],
            ),);
        }
        if(state.status == CatalogStatus.loaded && state.products.isNotEmpty){
          return Center(
            child: ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return ListTile(
                  onTap: () {
                    print("tapping product");
                    context.read<CartBloc>().add(
                        AddToCartEvent(product: product)
                    );
                    // context.read<CartRepository>()
                    // .addProductToCart(product, 1);
                    // setState(() {});
                  },
                  leading: Image.network(
                    product.imageUrl,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                  title: Text(product.name),
                  subtitle: Text(product.category),
                  trailing: Text('\$${product.price}'),
                );
              },
            ),
          );
        } else {
          return const Center(child: Text('Something went wrong'));
        }
  },
)
        );
  }
}
