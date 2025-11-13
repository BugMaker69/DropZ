// import 'package:drop_z_ecommerce_app/core/utils/styles.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// class ProductItemDetailsV3 extends StatelessWidget {
//   const ProductItemDetailsV3({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Column(
//         children: [
//           Text("Havic HV G-92 Gamepad", style: Styles.textStyle24SemiBold),
//           Image.asset("assets/images/coat.png"),

//           Text(r"$260", style: TextStyle(color: Color(0xff009336))),
//           SizedBox(height: 8),
//           Text(
//             "PlayStation 5 Controller Skin High quality vinyl with air channel adhesive for easy bubble free install & mess free removal Pressure sensitive.",
//             style: Styles.textStyle14Regular,
//           ),
//           SizedBox(height: 8),
//           FittedBox(
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 RatingBar.builder(
//                   initialRating: 3.5,
//                   minRating: 0,
//                   direction: Axis.horizontal,
//                   allowHalfRating: true,
//                   itemCount: 5,
//                   itemBuilder: (context, _) =>
//                       const Icon(Icons.star, color: Colors.amber),
//                   onRatingUpdate: (rating) {},
//                 ),
//                 Text(
//                   "(150 Reviews)",
//                   style: Styles.textStyle16Medium.copyWith(
//                     color: Color(0xff7F7F7F),
//                   ),
//                 ),
//                 Text(
//                   "In Stock",
//                   style: Styles.textStyle16Medium.copyWith(
//                     color: Color(0xff009336),
//                   ),
//                 ),
//                 SizedBox(width: 8),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoCard({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade300),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, size: 28, color: Colors.teal),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(subtitle, style: const TextStyle(color: Colors.grey)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class IncrementDecrement extends StatelessWidget {
//   const IncrementDecrement({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade400),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // زرار ناقص
//           InkWell(
//             onTap: () {},
//             child: Container(
//               width: 50,
//               height: 45,
//               alignment: Alignment.center,
//               child: const Text(
//                 "-",
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//           // الرقم
//           Container(
//             width: 50,
//             height: 45,
//             alignment: Alignment.center,
//             decoration: const BoxDecoration(
//               border: Border(
//                 left: BorderSide(color: Colors.grey),
//                 right: BorderSide(color: Colors.grey),
//               ),
//             ),
//             child: Text(
//               "0",
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//           ),
//           // زرار زائد (ملون)
//           InkWell(
//             onTap: () {},
//             child: Container(
//               width: 50,
//               height: 45,
//               decoration: BoxDecoration(
//                 color: Colors.teal.shade800,
//                 borderRadius: const BorderRadius.only(
//                   topRight: Radius.circular(8),
//                   bottomRight: Radius.circular(8),
//                 ),
//               ),
//               alignment: Alignment.center,
//               child: const Text(
//                 "+",
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
