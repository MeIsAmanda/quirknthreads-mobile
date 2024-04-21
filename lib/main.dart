import 'package:db_client/db_client.dart';
import 'package:ecommerce_with_flutter_firebase_and_stripe/repositories/checkout_repository.dart';
import 'package:ecommerce_with_flutter_firebase_and_stripe/repositories/order_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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

final dbClient = DbClient();
final paymentClient = PaymentClient();
final categoryRepository = CategoryRepository(dbClient: dbClient);
final productRepository = ProductRepository(dbClient: dbClient);
const cartRepository = CartRepository();
final orderRepository = OrderRepository(dbClient: dbClient);
final checkOutRepository = CheckoutRepository(paymentClient: paymentClient);

const userId = 'user_1234';
var cart = const Cart(
  userId: userId,
  cartItems: [],
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // // TODO: Add your Stripe publishable key here
  Stripe.publishableKey =
      'pk_test_51P1ThsDAIh3MeY43OlsDies6FTGvca6uvc9GBqNCwA0TCtiWmDUQQLxA01SsLMfvWupARQ7bSTkPGK3kIveSyd6h006HEdoU38';
  await Stripe.instance.applySettings();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // theme: const AppTheme().themeData,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CategoriesScreen(),
      onGenerateRoute: (settings) {
        if (settings.name == '/categories') {
          return MaterialPageRoute(
            builder: (context) => const CategoriesScreen(),
          );
        }
        if (settings.name == '/cart') {
          return MaterialPageRoute(
            builder: (context) => const CartScreen(),
          );
        }
        if (settings.name == '/checkout') {
          return MaterialPageRoute(
            builder: (context) => const CheckoutScreen(),
          );
        }
        if (settings.name == '/catalog') {
          return MaterialPageRoute(
            builder: (context) => CatalogScreen(
              // category: settings.arguments as String,
              category: settings.arguments as Category,
            ),
          );
        } else {
          return MaterialPageRoute(
            builder: (context) => const CategoriesScreen(),
          );
        }
      },
    );
  }
}
