// import 'package:dio/dio.dart';
// import 'package:drop_z_ecommerce_app/core/payment/const.dart';
// import 'package:drop_z_ecommerce_app/features/profile/data/models/get_user_data_success.dart';

// class PaymobManager {
//   Future<String> getPaymentKey(int amount, String currency) async {
//     try {
//       String authenticationToken = await _getAuthenticationToken();

//       int orderId = await _getOrderId(
//         authenticationToken: authenticationToken,
//         amount: (100 * amount)
//             .toString(), //!  (100*amount).toString() علي شان يحول الفلوس لقروش
//         currency: currency,
//       );

//       String paymentKey = await _getPaymentKey(
//         authenticationToken: authenticationToken,
//         orderId: orderId.toString(),
//         amount: (100 * amount).toString(),
//         currency: currency,
//       );
//       return paymentKey;
//     } catch (e) {
//       print("Error $e");
//       throw Exception();
//     }
//   }

//   Future<String> _getAuthenticationToken() async {
//     final Response response = await Dio().post(
//       "https://accept.paymob.com/api/auth/tokens",
//       data: {"api_key": API_KEY},
//     );
//     return response.data["token"];
//   }

//   Future<int> _getOrderId({
//     required String authenticationToken,
//     required String amount,
//     required String currency,
//   }) async {
//     final Response response = await Dio().post(
//       "https://accept.paymob.com/api/ecommerce/orders",
//       data: {
//         "auth_token": authenticationToken,
//         "amount_cents": amount,
//         "currency": currency,
//         "delivery_needed": "false",
//         "items": [],
//       },
//     );
//     return response.data["id"];
//   }

//   Future<String> _getPaymentKey({
//     required String authenticationToken,
//     required String orderId,
//     required String amount,
//     required String currency,
//     required GetUserDataSuccess userData,
//   }) async {
//     final Response response = await Dio().post(
//       "https://accept.paymob.com/api/acceptance/payment_keys",
//       data: {
//         "expiration": 3600,
//         "auth_token": authenticationToken,
//         "order_id": orderId,
//         "integration_id": CARD_PAYMENT_METHOD_INTEGRATION_ID,
//         "amount_cents": amount,
//         "currency": currency,

//         "billing_data": {
//           // Must Have Value
//           "first_name": userData.firstName,
//           "last_name": userData.lastName,
//           "email": userData.email,
//           "phone_number": userData.phoneNumber,

//           // May Have Value   OR just Put NA
//           "apartment": "NA",
//           "street": "NA",
//           "building": "NA",
//           "country": "NA",
//           "floor": "NA",
//           "state": "NA",
//           "shipping_method": "NA",
//           "postal_code": "NA",
//           "city": "NA",
//         },
//       },
//     );

//     return response.data["token"];
//   }

//   Future<GetUserDataSuccess> _getUserData() async{
//     final response =  await Dio().get("",);

//     return response.data;

//   }
// }
