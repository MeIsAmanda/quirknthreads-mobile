part of 'checkout_bloc.dart';

enum CheckoutStatus {initial, loading, loaded, error}

enum PaymentStatus {initial, loading, confirmationRequired, success, error}

class CheckoutState extends Equatable {
  final Cart? cart;
  final CheckoutStatus status;
  final PaymentStatus paymentStatus;
  final String? paymentMessage;
  final String? paymentClientSecret;
  final bool cardComplete;

  const CheckoutState({
    this.cart,
    this.status = CheckoutStatus.initial,
    this.paymentStatus = PaymentStatus.initial,
    this.paymentMessage,
    this.paymentClientSecret,
    this.cardComplete = false
});

  CheckoutState copyWith({
    Cart? cart,
    CheckoutStatus? status,
    PaymentStatus? paymentStatus,
    String? paymentMessage,
    String? paymentClientSecret,
    bool? cardComplete,
}) {
    return CheckoutState(
      cart: cart ?? this.cart,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMessage: paymentMessage ?? this.paymentMessage,
      paymentClientSecret: paymentClientSecret ?? this.paymentClientSecret,
      cardComplete: cardComplete ?? this.cardComplete,
    );
  }


  @override
  List<Object?> get props => [status, paymentStatus, cart, paymentMessage, paymentClientSecret, cardComplete];

}
