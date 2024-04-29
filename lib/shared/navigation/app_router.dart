import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/category.dart';
import '../../screens/cart_screen.dart';
import '../../screens/catalog_screen.dart';
import '../../screens/category_screen.dart';
import '../../screens/checkout_screen.dart';
import '../../screens/login_screen.dart';
import '../../screens/orders_screen.dart';
import '../../screens/register_screen.dart';
import '../../state/bloc/app_bloc.dart';
import 'go_router_refresh_stream.dart';

class AppRouter {
  final AppBloc appBloc;

  AppRouter({required this.appBloc});

  late final GoRouter router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        name: 'categories',
        path: '/categories',
        builder: (BuildContext context, GoRouterState state) {
          return const CategoriesScreen();
        },
        routes: [
          GoRoute(
            name: 'catalog',
            path: 'catalog/:categoryId',
            builder: (BuildContext context, GoRouterState state) {
              final categoryId = state.pathParameters['categoryId'] as String;
              return CatalogScreen(categoryId: categoryId);
            }
          )
        ]
      ),
      GoRoute(
          name: 'cart',
          path: '/cart',
          builder: (BuildContext context, GoRouterState state) {
            return const CartScreen();
          },
      ),
      GoRoute(
        name: 'checkout',
        path: '/checkout',
        builder: (BuildContext context, GoRouterState state) {
          return const CheckoutScreen();
        },
      ),
      GoRoute(
        name: 'login',
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        name: 'register',
        path: '/register',
        builder: (BuildContext context, GoRouterState state) {
          return const RegisterScreen();
        },
      ),
      GoRoute(
        name: 'orders',
        path: '/orders/:userId',
        builder: (BuildContext context, GoRouterState state) {
          final userId = state.pathParameters['userId'] as String;
          return OrdersScreen(userId: userId);
        },
      ),
    ],

    redirect: (context, state) {
      final isAuthenticated = appBloc.state.status == AppStatus.authenticated;
      final pendingEmail = appBloc.state.status == AppStatus.pendingEmail;
      final isLogin = state.matchedLocation == '/';
      final isRegister = state.matchedLocation == '/register';

      print ("isAuthenticated $isAuthenticated isLogin $isLogin isRegister $isRegister pendingEmail $pendingEmail");

      // if (!isAuthenticated && isLogin && pendingEmail) {
      //   return '/';
      // }


      if (isAuthenticated && isLogin) {
        return '/categories';
      }

      if (!isAuthenticated && !isLogin && !isRegister) {
        return '/';
      }

      return null;

    },

    refreshListenable: GoRouterRefreshStream(appBloc.stream),

  );


}