// payment_success_page.dart
import 'package:drop_z_ecommerce_app/core/utils/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart'; // أضف الحزمة دي في pubspec.yaml

class PaymentSuccessPage extends StatefulWidget {
  // final int paymentId;
  const PaymentSuccessPage({
    // required this.paymentId,
    super.key,
  });

  @override
  State<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 1), () {
      if (!context.mounted) return;
      context.go(AppRouter.kCustomerHome);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // الأيقونة الخضراء المتحركة (Lottie أجمل بكتير)
              Lottie.asset(
                'assets/animations/success.json', // هنضيف الملف ده بعدين
                controller: _controller,
                height: 200,
                onLoaded: (composition) {
                  _controller
                    ..duration = composition.duration
                    ..forward();
                },
              ),

              const SizedBox(height: 32),

              // النص الكبير
              const Text(
                "تم الدفع بنجاح!",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Text(
              //   "رقم العملية: ${widget.paymentId}",
              //   style: const TextStyle(fontSize: 18, color: Colors.grey),
              // ),
              const SizedBox(height: 40),

              // زر عرض الطلبات
              // SizedBox(
              //   width: double.infinity,
              //   height: 56,
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.green,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(16),
              //       ),
              //     ),
              //     onPressed: () {
              //       context.go('/orders'); // أو '/home'
              //     },
              //     child: const Text(
              //       "عرض الطلبات",
              //       style: TextStyle(fontSize: 18, color: Colors.white),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 16),

              // TextButton(
              //   onPressed: () => context.go('/'),
              //   child: const Text("العودة للرئيسية"),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
