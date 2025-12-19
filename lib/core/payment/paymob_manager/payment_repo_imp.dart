// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import 'package:drop_z_ecommerce_app/core/errors/failure.dart';
// // import 'package:drop_z_ecommerce_app/core/payment/const.dart';
// import 'package:drop_z_ecommerce_app/core/payment/paymob_manager/payment_repo.dart';
// import 'package:drop_z_ecommerce_app/core/utils/api_service.dart';
// import 'package:drop_z_ecommerce_app/features/profile/data/models/get_user_data_success.dart';

// class PaymentRepoImp extends PaymentRepo {
//   PaymentRepoImp(this.apiService);

//   ApiService apiService;

//   @override
//   Future<Either<Failure, String>> getAuthenticationToken() async {
//     try {
//       final response = await apiService.post(
//         newUrl: "https://accept.paymob.com/api",
//         endPoint: "/auth/tokens",
//         // data: {"api_key": API_KEY},
//       );
//       final token = response["token"];
//       print("TOKEN PAYMENT $token");
//       return right(token);
//     } catch (e) {
//       if (e is DioException) {
//         return left(ServerFailure.fromDioError(e));
//       }
//       return left(ServerFailure(e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, int>> getOrderId({
//     required String authenticationToken,
//     required String amount,
//     required String currency,
//   }) async {
//     try {
//       Dio().interceptors.add(
//         LogInterceptor(
//           request: true,
//           requestBody: true,
//           responseBody: true,
//           responseHeader: false,
//           error: true,
//         ),
//       );
//       // final response = await apiService.post(
//       final response = await Dio().post(
//         "https://accept.paymob.com/api/ecommerce/orders",
//         // newUrl: "https://accept.paymob.com/api",
//         // endPoint: "/ecommerce/orders",
//         // token: authenticationToken,
//         data: {
//           "auth_token": authenticationToken,
//           "amount_cents": amount,
//           "currency": currency,
//           "delivery_needed": "false",
//           "items": [],
//         },
//       );
//       // final id = response["id"];
//       final id = response.data["id"];
//       print("id PAYMENT $id");

//       return right(id);
//     } catch (e) {
//       if (e is DioException) {
//         return left(ServerFailure.fromDioError(e));
//       }
//       return left(ServerFailure(e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, String>> getPaymentKey({
//     required String authenticationToken,
//     required String orderId,
//     required String amount,
//     required String currency,
//     required GetUserDataSuccess userData,
//   }) async {
//     try {
//       Dio().interceptors.add(
//         LogInterceptor(
//           request: true,
//           requestBody: true,
//           responseBody: true,
//           responseHeader: false,
//           error: true,
//         ),
//       );
//       final response = await Dio().post(
//         "https://accept.paymob.com/api/acceptance/payment_keys",
//         // final response = await apiService.post(
//         //   newUrl: "https://accept.paymob.com/api",
//         //   endPoint: "/acceptance/payment_keys",
//         data: {
//           "expiration": 3600,
//           "auth_token": authenticationToken,
//           "order_id": orderId,
//           // "integration_id": CARD_PAYMENT_METHOD_INTEGRATION_ID,
//           "amount_cents": amount,
//           "currency": currency,

//           "billing_data": {
//             // Must Have Value
//             "first_name": userData.firstName,
//             "last_name": userData.lastName,
//             "email": userData.email,
//             "phone_number": userData.phoneNumber,

//             // May Have Value   OR just Put NA
//             "apartment": "NA",
//             "street": "NA",
//             "building": "NA",
//             "country": "NA",
//             "floor": "NA",
//             "state": "NA",
//             "shipping_method": "NA",
//             "postal_code": "NA",
//             "city": "NA",
//           },
//         },
//       );

//       final token = response.data["token"];
//       // final token = response["token"];
//       print("TOKEN PAYMENT $token");

//       return right(token);
//     } catch (e) {
//       if (e is DioException) {
//         return left(ServerFailure.fromDioError(e));
//       }
//       return left(ServerFailure(e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, GetUserDataSuccess>> getUserData() async {
//     try {
//       final response = await apiService.get(endPoint: "/accounts/users/me/");
//       GetUserDataSuccess getUserDataSuccess = GetUserDataSuccess.fromJson(
//         response,
//       );
//       return right(getUserDataSuccess);
//     } catch (e) {
//       if (e is DioException) {
//         return left(ServerFailure.fromDioError(e));
//       }
//       return left(ServerFailure(e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, String>> getFinalPaymentKey({
//     required int amount,
//     required String currency,
//   }) async {
//     try {
//       // Get authentication token
//       final authResult = await getAuthenticationToken();
//       final authenticationToken = authResult.fold(
//         (failure) => throw failure, // handle error
//         (token) => token,
//       );

//       // Get order ID
//       final orderResult = await getOrderId(
//         authenticationToken: authenticationToken,
//         amount: (100 * amount).toString(), // convert to cents
//         currency: currency,
//       );
//       final orderId = orderResult.fold((failure) => throw failure, (id) => id);

//       // Get payment key
//       final paymentKeyResult = await getPaymentKey(
//         authenticationToken: authenticationToken,
//         orderId: orderId.toString(),
//         amount: (100 * amount).toString(),
//         currency: currency,
//         userData: await getUserData().then(
//           (res) => res.fold((f) => throw f, (data) => data),
//         ),
//       );

//       final paymentKey = paymentKeyResult.fold(
//         (failure) => throw failure,
//         (key) => key,
//       );
//       print("paymentKey PAYMENT $paymentKey");

//       return right(paymentKey);
//     } catch (e) {
//       if (e is Failure) return left(e);
//       return left(ServerFailure(e.toString()));
//     }
//   }
// }
