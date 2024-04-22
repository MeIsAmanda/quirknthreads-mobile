import 'package:ecommerce_with_flutter_firebase_and_stripe/repositories/checkout_repository.dart';
import 'package:ecommerce_with_flutter_firebase_and_stripe/repositories/order_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../main.dart';
import '../state/bloc/app_bloc.dart';
import '../state/cart/cart_bloc.dart';
import '../state/checkout/checkout_bloc.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = context.watch<AppBloc>().state.user?.uid;
    final cart = context.watch<CartBloc>().state.cart;
    return BlocProvider(
      create: (context) => CheckoutBloc(
        orderRepository: context.read<OrderRepository>(),
        checkoutRepository: context.read<CheckoutRepository>(),
      )..add(
        LoadCheckoutEvent(userId: userId ?? '', cart: cart),
      ),
      child: const CheckoutView(),
    );
  }
}

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme
        .of(context)
        .textTheme;

    final cart = context.watch<CartBloc>().state.cart;

    final checkout = context.watch<CheckoutBloc>().state;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Checkout', style: textTheme.headlineSmall),
      ),
      body: BlocConsumer<CheckoutBloc, CheckoutState>(
  listener: (context, state) {
    if(state.paymentStatus == PaymentStatus.error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16.0),
            content: Text(state.paymentMessage ?? ''),
          )
      );
    }
    if(state.paymentStatus == PaymentStatus.success) {
      if(state.paymentStatus == PaymentStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16.0),
              content: Text(
                state.paymentMessage ?? 'The payment was successful!',
              ),
            )
        );
      }
    }
  },
  builder: (context, state) {
    if (state.status == CheckoutStatus.loading ||
    state.status == CheckoutStatus.initial){
      return const Center(child: CircularProgressIndicator());
    }
    if (state.status == CheckoutStatus.loaded) {
    return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Insert your card details',
                style: textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              CardFormField(
                onCardChanged: (card) {
                  context.read<CheckoutBloc>().add(
                    UpdateCardCompleteStatus(
                        cardComplete: card?.complete ?? false),
                  );
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
                onPressed:
                 checkout.paymentStatus == PaymentStatus.loading ?() {}: () {
                  if (!checkout.cardComplete){
                    // show snackbar to complete card details
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.all(16.0),
                          content: Text('Please complete the card details'),
                        )
                    );
                    return;
                  }
                  context.read<CheckoutBloc>().add(StartCheckoutEvent());
                 },
                child: checkout.paymentStatus == PaymentStatus.loading
                  ? const CircularProgressIndicator()
                  : const Text('Pay Now')
            ),

            )
          ],
        ),
      ),
    );
  }

  // handlePayment() async {
  //   if (_card?.complete != true) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Please fill in your card details'),
  //       ),
  //     );
  //     return;
  //   }
  //
  //   setState(() {
  //     loading = true;
  //   });
  //
  //   try {
  //     await processPayment();
  //   } catch (err) {
  //     throw Exception(err.toString());
  //   } finally {
  //     if (mounted) {
  //       setState(() {
  //         loading = false;
  //       });
  //     }
  //   }
  // }

  // processPayment() async {
  //   //use the information without accessing the details to avoid compromising the data
  //   final paymentMethod = await Stripe.instance.createPaymentMethod(
  //     params: const PaymentMethodParams.card(
  //       paymentMethodData: PaymentMethodData(),
  //     ),
  //   );
  //
  //   // final response = await paymentClient.processPayment(
  //   //   paymentMethodId: paymentMethod.id,
  //   //   items: cart.cartItems.map((cartItem) => cartItem.toJson()).toList(),
  //   // );
  //   //
  //   // print(response);
  //   // if (response['requiresAction'] == true &&
  //   //     response['clientSecret'] != null) {
  //   //   final paymentIntent =
  //   //       await Stripe.instance.handleNextAction(response['clientSecret']);
  //   //
  //   //   print(paymentIntent);
  //   //   if (paymentIntent.status == PaymentIntentsStatus.RequiresConfirmation) {
  //   //   final response = await paymentClient.confirmPayment(
  //   //     paymentIntentId: paymentIntent.id,
  //   //   );
  //   //
  //   //   print(response);
  //   //   }
  //   // }
  //
  //
  // }
}
