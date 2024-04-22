import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:payment_client/payment_client.dart';

import '../models/order_status.dart';

class CheckoutRepository {
  final PaymentClient paymentClient;

  const CheckoutRepository({required this.paymentClient});

  Future<PaymentMethod> createPaymentMethod() async {
    final paymentMethod = await Stripe.instance.createPaymentMethod(
      params: const PaymentMethodParams.card(
        paymentMethodData: PaymentMethodData(),
      ),
    );
    return paymentMethod;
  }

  Future<Map<String, dynamic>> processPayment({
    required String paymentMethodId,
    required List<Map<String,dynamic>> items,
}) async {
    try{
      final response = await paymentClient.processPayment(
        paymentMethodId: paymentMethodId,
        items: items,
      );
      if (response['error'] != null){
        return{
          'status': OrderStatus.paymentFailed,
          'message': response['error'],
        };
      }
      if(response['clientSecret']!= null &&
      response['requiresAction'] == true) {
        return{
          'status': OrderStatus.waitingForPaymentConfirmation,
          'message':
              'The payment requires authentication or additional confirmation',
          'clientSecret': response['clientSecret'],
        };
      }
      if(response['clientSecret']!= null &&
          response['requiresAction'] == null) {
        return{ //successful
          'status': OrderStatus.processing,
          'message': 'We successfully processed the payment',
        };
      }
      return{
        'status': OrderStatus.paymentFailed,
        'message': 'Something went wrong processing the payment',
      };
    } catch (err) {
      throw Exception('Error processing payment: $err');
    }
  }

  Future<Map<String, dynamic>> confirmPayment({
    required String clientSecret,
  }) async {
    final paymentIntent =
        await Stripe.instance.handleNextAction(clientSecret);

    if (paymentIntent.status == PaymentIntentsStatus.RequiresConfirmation){
      final response = await paymentClient.confirmPayment(
          paymentIntentId: paymentIntent.id,
      );

      if (response['error'] != null) {
        return {
          'status': OrderStatus.paymentFailed,
          'message': response['error'],
        };
      }

      if (response['clientSecret'] != null &&
          response['requiresAction'] == null) {
        return {
          'status': OrderStatus.processing,
          'message': "We successfully processed the payment",
        };
      }

    }

    if (paymentIntent.status == PaymentIntentsStatus.Succeeded){
      return {
        'status': OrderStatus.processing,
        'message': "We successfully processed the payment",
      };
    }
    return {
      'status': OrderStatus.paymentFailed,
      'message': 'Something went wrong processing the payment',
    };

  }
  
}