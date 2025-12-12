abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {
  final String iframeUrl;
  final int orderId;

  PaymentSuccess(this.iframeUrl, this.orderId);
}

class PaymentError extends PaymentState {
  final String message;
  PaymentError(this.message);
}

class PaymentStatusLoading extends PaymentState {}

class PaymentStatusSuccess extends PaymentState {
  final bool isPaid;
  PaymentStatusSuccess(this.isPaid);
}

class PaymentStatusError extends PaymentState {
  final String message;
  PaymentStatusError(this.message);
}
