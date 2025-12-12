// payment_failed_page.dart
import 'package:drop_z_ecommerce_app/core/utils/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class PaymentFailedPage extends StatefulWidget {
  // final int paymentId;
  const PaymentFailedPage({
    // required this.paymentId,
    super.key,
  });

  @override
  State<PaymentFailedPage> createState() => _PaymentFailedPageState();
}

class _PaymentFailedPageState extends State<PaymentFailedPage>
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
              // الأيقونة الحمراء المتحركة
              Lottie.asset(
                'assets/animations/failed.json',
                controller: _controller,
                height: 200,
                onLoaded: (composition) {
                  _controller
                    ..duration = composition.duration
                    ..forward();
                },
              ),

              const SizedBox(height: 32),

              const Text(
                "فشل في عملية الدفع",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              const Text(
                "حدث خطأ أثناء الدفع، يرجى المحاولة مرة أخرى",
                style: TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Text(
              //   "رقم العملية: ${widget.paymentId}",
              //   style: const TextStyle(color: Colors.grey),
              // ),
              const SizedBox(height: 40),

              // زر المحاولة مرة أخرى
              // SizedBox(
              //   width: double.infinity,
              //   height: 56,
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.red,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(16),
              //       ),
              //     ),
              //     onPressed: () {
              //       context.pop(); // رجع للـ Checkout
              //     },
              //     child: const Text(
              //       "حاول مرة أخرى",
              //       style: TextStyle(fontSize: 18, color: Colors.white),
              //     ),
              //   ),
              // ),

              // const SizedBox(height: 16),

              // TextButton(
              //   onPressed: () => context.go('/cart'),
              //   child: const Text("العودة للعربة"),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
