import 'package:drop_z_ecommerce_app/core/payment/payment_cubit/payment_state.dart';
import 'package:drop_z_ecommerce_app/core/utils/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit(this.apiService) : super(PaymentInitial());

  ApiService apiService;

  //   final Dio dio = Dio(
  //     BaseOptions(baseUrl: "https://your-backend-domain.com/api"),
  //   );

  /// Step 1: Start Payment → Get iframe URL
  Future<void> startPayment(String orderId) async {
    emit(PaymentLoading());

    try {
      final response = await apiService.post(
        endPoint: "/payments/pay/$orderId/",
      );

      // final iframeUrl = response["iframe_url"];
      print("response[payment][id] ${response["payment"]["id"]}");

      emit(PaymentSuccess(response["iframe_url"], response["payment"]["id"]));
    } catch (e) {
      emit(PaymentError(e.toString()));
    }
  }

  /// Step 2: Check Payment Status
  Future<void> checkPaymentStatus(int paymentId) async {
    emit(PaymentStatusLoading());

    try {
      final response = await apiService.get(
        endPoint: "/payments/status/$paymentId/",
      );

      final isPaid = response["is_paid"];

      emit(PaymentStatusSuccess(isPaid));
    } catch (e) {
      emit(PaymentStatusError(e.toString()));
    }
  }
}
