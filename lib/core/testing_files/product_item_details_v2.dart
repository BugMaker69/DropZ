// import 'package:drop_z_ecommerce_app/core/utils/styles.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// class ProductItemDetailsV2 extends StatelessWidget {
//   const ProductItemDetailsV2({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // ====== الصورة (شمال) ======
//               Expanded(
//                 flex: 1,
//                 child: Image.asset("assets/images/coat.png", height: 300),
//               ),
//               const SizedBox(width: 20),

//               // ====== التفاصيل (يمين) ======
//               Expanded(
//                 flex: 2,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Havic HV G-92 Gamepad",
//                         style: const TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 8),

//                       Row(
//                         children: const [
//                           Icon(Icons.star, color: Colors.amber, size: 20),
//                           Icon(Icons.star, color: Colors.amber, size: 20),
//                           Icon(Icons.star, color: Colors.amber, size: 20),
//                           Icon(Icons.star, color: Colors.amber, size: 20),
//                           Icon(Icons.star_border, color: Colors.grey, size: 20),
//                           SizedBox(width: 6),
//                           Text(
//                             "(150 Reviews)",
//                             style: TextStyle(color: Colors.grey),
//                           ),
//                           SizedBox(width: 10),
//                           Text(
//                             "| In Stock",
//                             style: TextStyle(color: Colors.green),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 12),

//                       const Text(
//                         "\$192.00",
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 12),

//                       const Text(
//                         "PlayStation 5 Controller Skin High quality vinyl with air channel adhesive for easy bubble free install & mess free removal Pressure sensitive.",
//                         style: TextStyle(color: Colors.grey),
//                       ),

//                       const Divider(height: 30),

//                       const SizedBox(height: 20),

//                       // ====== المقاسات ======
//                       const Text(
//                         "Size:",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 8),

//                       const SizedBox(height: 20),

//                       // ====== الكمية + زرار الشراء ======
//                       Row(
//                         children: [
//                           Container(
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Colors.grey),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: IncrementDecrement(),
//                           ),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.teal.shade800,
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 14,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                               ),
//                               onPressed: () {},
//                               child: const Text("Buy Now"),
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           IconButton(
//                             onPressed: () {},
//                             icon: const Icon(Icons.favorite_border),
//                           ),
//                         ],
//                       ),

//                       const SizedBox(height: 20),

//                       // ====== Free Delivery ======
//                       _buildInfoCard(
//                         icon: Icons.local_shipping_outlined,
//                         title: "Free Delivery",
//                         subtitle:
//                             "Enter your postal code for Delivery Availability",
//                       ),
//                       const SizedBox(height: 12),
//                       _buildInfoCard(
//                         icon: Icons.refresh,
//                         title: "Return Delivery",
//                         subtitle: "Free 30 Days Delivery Returns. Details",
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
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
