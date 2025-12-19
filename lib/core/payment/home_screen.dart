// import 'dart:async';

// import 'package:drop_z_ecommerce_app/core/payment/paymob_manager/payment_repo_imp.dart';
// import 'package:drop_z_ecommerce_app/core/utils/api_service.dart';
// import 'package:drop_z_ecommerce_app/core/utils/service_locator.dart';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("PayMob")),
//       body: ElevatedButton(
//         onPressed: () async => _pay(),
//         child: Text("Pay 10 Egp"),
//       ),
//     );
//   }

//   Future<void> _pay() async {
//     final repo = PaymentRepoImp(getIt.get<ApiService>());

//     final result = await repo.getFinalPaymentKey(amount: 10, currency: "EGP");

//     result.fold(
//       (failure) {
//         // Handle error
//         print("Payment key error: ${failure.toString()}");
//       },
//       (paymentKey) async {
//         // Success: launch payment iframe
//         final url = Uri.parse(
//           "https://accept.paymob.com/api/acceptance/iframes/979798?payment_token=$paymentKey",
//         );
//         await launchUrl(url);
//       },
//     );
//   }

//   /* Future<void> _pay() async {
//     PaymentRepoImp(getIt.get<ApiService>())
//         .getFinalPaymentKey(amount: 10, currency: "EGP")
//         .then(
//           (String paymentKey) {
//                 launchUrl(
//                   Uri.parse(
//                     "https://accept.paymob.com/api/acceptance/iframes/979798?payment_token=$paymentKey",
//                   ),
//                 );
//               }
//               as FutureOr Function(Either<Failure, String> value),
//         );
//   }
// */
// }
