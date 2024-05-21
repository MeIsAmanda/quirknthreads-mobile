import 'dart:async';

import 'package:quirknthreads/repositories/cart_repository.dart';
import 'package:quirknthreads/repositories/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';


import '../main.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../repositories/category_repository.dart';
import '../repositories/order_repository.dart';
import '../state/cart/cart_bloc.dart';
import '../state/catalog/catalog_bloc.dart';
import '../state/order/order_bloc.dart';

class OrdersScreen extends StatelessWidget{
  const OrdersScreen({
    super.key,
    required this.userId,
  });
  
  final String userId;
  
  @override
  Widget build(BuildContext context){
    return BlocProvider(
        create: (context) => OrderBloc(
        orderRepository: context.read<OrderRepository>(),
        productRepository: context.read<ProductRepository>())
      ..add(LoadOrdersEvent(userId: userId)),
    child: OrderView(),
    );
  }
}

class OrderView extends StatelessWidget {
  const OrderView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('Order History'),

        ),
        body: BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        print("building orders screen");
        print(state.orders);
        if (state.status == OrderStatus.loading || state.status == OrderStatus.initial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == OrderStatus.loaded && state.orders.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [

                const SizedBox(height: 32.0),
                Text('No Past Orders Found!',
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyLarge
                ),
              ],
            ),);
        }
        if(state.status == OrderStatus.loaded && state.orders.isNotEmpty){
          return Center(
            child: ListView.builder(
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                final order = state.orders[index];
                String formattedDate = DateFormat.yMMMd().add_jm().format(order.date.toDate());
                return ListTile(
                  onTap: () {
                    print("tapping product");
                    //TODO: Order detail here
                  },
                  title: Text(order.id),
                  subtitle: Text(formattedDate),
                  trailing: Text(order.totalAmount.toString()),
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
