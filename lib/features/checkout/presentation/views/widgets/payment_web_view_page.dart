import 'package:drop_z_ecommerce_app/core/payment/payment_cubit/payment_cubit.dart';
import 'package:drop_z_ecommerce_app/core/payment/payment_cubit/payment_state.dart';
import 'package:drop_z_ecommerce_app/core/utils/app_router.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_loading_indicator.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_snakebar_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewPage extends StatelessWidget {
  final String iframeUrl;
  final int orderId;

  const PaymentWebViewPage({
    super.key,
    required this.iframeUrl,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> isLoading = ValueNotifier(true);

    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onUrlChange: (change) {
            final url = change.url;
            if (!url!.contains("accept.paymob.com")) {
              isLoading.value = true;

              final cubit = context
                  .read<PaymentCubit>(); // خذ context هنا مباشرة

              // لا تستخدم context بعد await طويل
              Future(() async {
                await Future.delayed(const Duration(seconds: 20));
                await cubit.checkPaymentStatus(orderId);

                final state = cubit.state;

                if (!context.mounted) return; // تأكد أن context صالح

                GoRouter.of(context).pop(); // اغلق WebView

                if (state is PaymentStatusSuccess) {
                  if (state.isPaid) {
                    GoRouter.of(
                      context,
                    ).pushReplacement(AppRouter.kCustomerPaymentSuccess);
                  } else {
                    GoRouter.of(
                      context,
                    ).pushReplacement(AppRouter.kCustomerPaymentFailed);
                  }

                  // Future.delayed(const Duration(milliseconds: 800), () {
                  //   if (!context.mounted) return;
                  //   GoRouter.of(context).go(AppRouter.kCustomerHome);
                  // });
                } else if (state is PaymentStatusError) {
                  CustomSnakeBar(context, "Error: ${state.message}");
                }

                isLoading.value = false;
              });
            }
          },
          onPageStarted: (url) {
            isLoading.value = true;
          },
          onPageFinished: (url) {
            isLoading.value = false;
          },
        ),
      )
      ..loadRequest(Uri.parse(iframeUrl));

    return Scaffold(
      appBar: AppBar(title: const Text("Complete Payment")),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          ValueListenableBuilder<bool>(
            valueListenable: isLoading,
            builder: (_, loading, __) {
              if (!loading) return const SizedBox.shrink();
              return const CustomLoadingIndicator();
            },
          ),
        ],
      ),
    );
  }
}

/*
class PaymentWebViewPage extends StatelessWidget {
  final String iframeUrl;
  final int orderId;

  const PaymentWebViewPage({
    super.key,
    required this.iframeUrl,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> isLoading = ValueNotifier(true);

    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onUrlChange: (change) async {
            final url = change.url;

            // المستخدم خرج من iframe الدفع
            if (!url!.contains("accept.paymob.com")) {
              isLoading.value = true;
              final cubit = context.read<PaymentCubit>();

              await Future.delayed(const Duration(seconds: 20));

              // اطلب حالة الدفع من backend
              await cubit.checkPaymentStatus(orderId);

              // بعد ما تجيب النتيجة، اعمل navigation
              final state = cubit.state;
              if (state is PaymentStatusSuccess) {
                GoRouter.of(context).pop(); // اغلق الـ WebView
                if (state.isPaid) {
                  GoRouter.of(
                    context,
                  ).pushReplacement(AppRouter.kCustomerPaymentSuccess);
                } else {
                  GoRouter.of(
                    context,
                  ).pushReplacement(AppRouter.kCustomerPaymentFailed);
                }
                Future.delayed(const Duration(milliseconds: 300), () {
                  if (!context.mounted) return;
                  context.go(AppRouter.kCustomerHome);
                });
              } else if (state is PaymentStatusError) {
                GoRouter.of(context).pop(); // اغلق الـ WebView
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error: ${state.message}")),
                );
              }

              isLoading.value = false;
            }
          },
          onPageStarted: (url) {
            isLoading.value = true;
          },
          onPageFinished: (url) {
            isLoading.value = false;
          },
        ),
      )
      ..loadRequest(Uri.parse(iframeUrl));

    return Scaffold(
      appBar: AppBar(title: const Text("Complete Payment")),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          ValueListenableBuilder<bool>(
            valueListenable: isLoading,
            builder: (_, loading, __) {
              if (!loading) return const SizedBox.shrink();
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }
}
*/

/**
 * class PaymentWebViewPage extends StatelessWidget {
  final String iframeUrl;
  final int orderId;

  const PaymentWebViewPage({
    super.key,
    required this.iframeUrl,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> isLoading = ValueNotifier(true);

    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onUrlChange: (change) async {
            final url = change.url;

            if (!url!.contains("accept.paymob.com")) {
              isLoading.value = true;

              // اطلب حالة الدفع من backend
              final cubit = context.read<PaymentCubit>();
              await cubit.checkPaymentStatus(orderId);

              if (!context.mounted) return; // Safety check

              final state = cubit.state;

              // اغلق WebView
              GoRouter.of(context).pop();

              if (state is PaymentStatusSuccess) {
                if (state.isPaid) {
                  GoRouter.of(context).pushReplacement(AppRouter.kCustomerPaymentSuccess);
                } else {
                  GoRouter.of(context).pushReplacement(AppRouter.kCustomerPaymentFailed);
                }

                // بعد ثانية واحدة، ارجع للصفحة الرئيسية
                Future.delayed(const Duration(seconds: 1), () {
                  if (!context.mounted) return;
                  context.go(AppRouter.kCustomerHome);
                });
              } else if (state is PaymentStatusError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error: ${state.message}")),
                );
              }

              isLoading.value = false;
            }
          },
          onPageStarted: (url) => isLoading.value = true,
          onPageFinished: (url) => isLoading.value = false,
        ),
      )
      ..loadRequest(Uri.parse(iframeUrl));

    return Scaffold(
      appBar: AppBar(title: const Text("Complete Payment")),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          ValueListenableBuilder<bool>(
            valueListenable: isLoading,
            builder: (_, loading, __) =>
                loading ? const Center(child: CircularProgressIndicator()) : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

 */

/**
 * 
class PaymentWebViewPage extends StatelessWidget {
  final String iframeUrl;
  final int orderId; // رقم الـ payment من backend

  const PaymentWebViewPage({
    super.key,
    required this.iframeUrl,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> isLoading = ValueNotifier(true);

    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onUrlChange: (change) async {
            final url = change.url;

            // لو العملية انتهت سواء نجاح أو فشل
            if (url!.contains("payment-success") ||
                url.contains("payment-failed")) {
              isLoading.value = true;

              // نعمل الريكويست على backend للتحقق من الدفع
              await context.read<PaymentCubit>().checkPaymentStatus(orderId);

              final state = context.read<PaymentCubit>().state;

              if (state is PaymentStatusSuccess) {
                if (state.isPaid) {
                  Navigator.pushReplacementNamed(context, "/payment_success");
                } else {
                  Navigator.pushReplacementNamed(context, "/payment_failed");
                }
              } else if (state is PaymentStatusError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Error checking payment status: ${state.message}",
                    ),
                  ),
                );
                Navigator.pop(context); // اغلاق الـ WebView
              }
            }
          },
          onPageStarted: (url) {
            isLoading.value = true;
          },
          onPageFinished: (url) {
            isLoading.value = false;
          },
        ),
      )
      ..loadRequest(Uri.parse(iframeUrl));

    return Scaffold(
      appBar: AppBar(title: const Text("Complete Payment")),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          ValueListenableBuilder<bool>(
            valueListenable: isLoading,
            builder: (_, loading, __) {
              if (!loading) return const SizedBox.shrink();
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }
}

 */
