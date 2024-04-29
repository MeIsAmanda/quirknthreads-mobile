import 'package:auth_client/auth_client.dart';
import 'package:db_client/db_client.dart';
import 'package:ecommerce_with_flutter_firebase_and_stripe/repositories/auth_repository.dart';
import 'package:ecommerce_with_flutter_firebase_and_stripe/repositories/checkout_repository.dart';
import 'package:ecommerce_with_flutter_firebase_and_stripe/repositories/order_repository.dart';
import 'package:ecommerce_with_flutter_firebase_and_stripe/screens/login_screen.dart';
import 'package:ecommerce_with_flutter_firebase_and_stripe/screens/register_screen.dart';
import 'package:ecommerce_with_flutter_firebase_and_stripe/shared/navigation/app_router.dart';
import 'package:ecommerce_with_flutter_firebase_and_stripe/state/bloc/app_bloc.dart';
import 'package:ecommerce_with_flutter_firebase_and_stripe/state/cart/cart_bloc.dart';
import 'package:ecommerce_with_flutter_firebase_and_stripe/state/category/category_bloc.dart';
import 'package:ecommerce_with_flutter_firebase_and_stripe/state/order/order_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:payment_client/payment_client.dart';

import 'firebase_options.dart';
import 'models/cart.dart';
import 'models/category.dart';
import 'repositories/cart_repository.dart';
import 'repositories/category_repository.dart';
import 'repositories/product_repository.dart';
import 'screens/cart_screen.dart';
import 'screens/catalog_screen.dart';
import 'screens/category_screen.dart';
import 'screens/checkout_screen.dart';


// const userId = 'user_1234';
// var cart = const Cart(
//   userId: userId,
//   cartItems: [],
// );

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final authClient = AuthClient();
  final dbClient = DbClient();
  final paymentClient = PaymentClient();

  final authRepository = AuthRepository(
      authClient: authClient, dbClient: dbClient);
  final categoryRepository = CategoryRepository(dbClient: dbClient);
  final productRepository = ProductRepository(dbClient: dbClient);
  const cartRepository = CartRepository();
  final orderRepository = OrderRepository(dbClient: dbClient);
  final checkoutRepository = CheckoutRepository(paymentClient: paymentClient);


  // Stripe publishable key here
  // This is not secret
  Stripe.publishableKey =
  'pk_test_51P1ThsDAIh3MeY43OlsDies6FTGvca6uvc9GBqNCwA0TCtiWmDUQQLxA01SsLMfvWupARQ7bSTkPGK3kIveSyd6h006HEdoU38';
  await Stripe.instance.applySettings();
  runApp(
    MyApp(
      authRepository: authRepository,
      categoryRepository: categoryRepository,
      productRepository: productRepository,
      cartRepository: cartRepository,
      orderRepository: orderRepository,
      checkoutRepository: checkoutRepository,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key,
    required this.authRepository,
    required this.categoryRepository,
    required this.productRepository,
    required this.cartRepository,
    required this.orderRepository,
    required this.checkoutRepository,
  });

  final AuthRepository authRepository;
  final CategoryRepository categoryRepository;
  final ProductRepository productRepository;
  final CartRepository cartRepository;
  final OrderRepository orderRepository;
  final CheckoutRepository checkoutRepository;


  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: categoryRepository),
        RepositoryProvider.value(value: productRepository),
        RepositoryProvider.value(value: cartRepository),
        RepositoryProvider.value(value: orderRepository),
        RepositoryProvider.value(value: checkoutRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            lazy: false,
            create: (context) => AppBloc(
              authRepository: authRepository,
            ),
          ),

          BlocProvider(
            create: (context) =>
                CategoryBloc(
                    categoryRepository: categoryRepository
                )..add(const LoadCategoriesEvent()),
          ),
          BlocProvider(
            lazy: false,
            create: (context) => CartBloc()
              ..add(
                LoadCartEvent(userId: authRepository.currentUser?.uid
                ),
            ),
          ),
          BlocProvider(
            lazy: true,
            create: (context) => OrderBloc(orderRepository: orderRepository,
                productRepository: productRepository)
              ..add(
                LoadOrdersEvent(userId: authRepository.currentUser!.uid
                ),
              ),
          ),

        ],
        child: Builder(
          builder: (context) {
            final cart = context.watch<CartBloc>().state.cart;
            print("main builder");
            print(cart);
            return MaterialApp.router(
              title: 'Quirk n Threads',
              // theme: const AppTheme().themeData,
              routerConfig: AppRouter(appBloc: context.read<AppBloc>()).router,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),

            );
          }
        ),
      ),
    );
  }
}
