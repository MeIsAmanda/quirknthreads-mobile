import 'dart:math';

import 'package:ecommerce_with_flutter_firebase_and_stripe/main.dart';
import 'package:ecommerce_with_flutter_firebase_and_stripe/models/category.dart';
import 'package:ecommerce_with_flutter_firebase_and_stripe/repositories/category_repository.dart';
import 'package:ecommerce_with_flutter_firebase_and_stripe/state/cart/cart_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

import '../repositories/auth_repository.dart';
import '../state/bloc/app_bloc.dart';
import '../state/category/category_bloc.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appBlocState = context
        .watch<AppBloc>()
        .state;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          title: const Text('Categories'),
          actions: [
            (appBlocState.status == AppStatus.authenticated) ?
            IconButton(onPressed: () {
              context.read<AppBloc>().add(AppLogoutRequested());
            }, icon: const Icon(Icons.logout))
                : IconButton(
              onPressed: () {
                context.goNamed('login');
              },
              icon: const Icon(Icons.login),
            )
          ]
      ),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state.status == CategoryStatus.loading ||
              state.status == CategoryStatus.initial) {
            return const Center(
              child: CircularProgressIndicator());
          }
          if(state.status == CategoryStatus.loaded) {
            final extents = List<int>.generate(
              state.categories.length,
                (int index) => Random().nextInt(2) + 2,
            );

          return MasonryGridView.count(
            padding: const EdgeInsets.only(
              top: 120,
              left: 4.0,
              right: 4.0,
            ),
            crossAxisCount: 3,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            itemCount: state.categories.length,
            itemBuilder: (context, index) {
              final height = extents[index] * 100;
              final category = state.categories[index];
              return InkWell(
                onTap: () {
                  context.pushNamed('catalog',
                    pathParameters: {'categoryId': category.id},
                  );
                },
                child: Hero(
                  tag: category.id,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: NetworkImage(category.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                    height: height.toDouble(),
                  ),
                ),
              );
            },
          );
          } else {
            return const Center(child: Text('Something Went wrong!'));
          }
        },
      ),
    );
  }
}
