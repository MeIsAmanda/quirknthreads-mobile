enum OrderStatus {
  pending(
    'Pending',
    'The order has been placed but not yet processed.',
  ),
  processing(
    'Processing',
    'The order is being processed by the platform.',
  ),
  shipped(
    'Shipped',
    'The order has been shipped to the customer.',
  ),
  delivered(
    'Delivered',
    'The order has been delivered to the customer.',
  ),
  cancelled(
    'Cancelled',
    'The order has been cancelled.',
  ),
  waitingForPaymentConfirmation(
    'Waiting for payment confirmation',
    'The order is waiting for payment',
  ),
  paymentFailed(
    'Payment Failed',
    'The payment failed.',
  );

  const OrderStatus(
      this.label,
      this.description
  );

  final String label;
  final String description;
  
}