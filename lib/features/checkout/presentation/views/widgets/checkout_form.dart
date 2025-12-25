import 'package:cached_network_image/cached_network_image.dart';
import 'package:drop_z_ecommerce_app/core/payment/payment_cubit/payment_cubit.dart';
import 'package:drop_z_ecommerce_app/core/payment/payment_cubit/payment_state.dart';
import 'package:drop_z_ecommerce_app/core/utils/app_router.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_button.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_cached_network_image.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_loading_indicator.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_snakebar_message.dart';
import 'package:drop_z_ecommerce_app/features/address/data/model/address_response/address_response.dart';
import 'package:drop_z_ecommerce_app/features/address/presentation/manager/address_cubit/address_cubit.dart';
import 'package:drop_z_ecommerce_app/features/biometrics/presentation/manager/biometric_cubit/biometrics_cubit.dart';
import 'package:drop_z_ecommerce_app/features/biometrics/presentation/manager/biometric_cubit/biometrics_state.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/model/cart_items_model/cart_model.dart';
import 'package:drop_z_ecommerce_app/features/cart/presentation/manager/cart_cubit/cart_cubit.dart';
import 'package:drop_z_ecommerce_app/features/checkout/presentation/manager/checkout_cubit/checkout_cubit.dart';
import 'package:drop_z_ecommerce_app/features/checkout/presentation/manager/checkout_cubit/checkout_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CheckoutForm extends StatelessWidget {
  const CheckoutForm({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddressCubit>().getAllAddresses();
    });

    final ValueNotifier<int?> selectedAddressId = ValueNotifier(null);
    final ValueNotifier<bool> isPaymentLoading = ValueNotifier(false);

    return Stack(
      children: [
        MultiBlocListener(
          listeners: [
            BlocListener<PaymentCubit, PaymentState>(
              listener: (context, paymentState) async {
                if (paymentState is PaymentSuccess) {
                  isPaymentLoading.value = false;

                  context.push(
                    AppRouter.kCustomerPaymentWebView,
                    extra: {
                      "url": paymentState.iframeUrl,
                      "orderId": paymentState.orderId,
                    },
                  );
                } else if (paymentState is PaymentError) {
                  isPaymentLoading.value = false;
                  CustomSnakeBar(
                    context,
                    "Payment failed: ${paymentState.message}",
                  );
                }
              },
            ),
            BlocListener<BiometricsCubit, BiometricsState>(
              listener: (context, state) {
                if (state is BiometricsSuccess || state is BiometricsSkipped) {
                  context.read<CheckoutCubit>().createCheckoutOrder();
                }
                if (state is BiometricsFailed) {
                  CustomSnakeBar(context, "Authentication failed");
                }
              },
            ),
          ],
          child: BlocConsumer<CheckoutCubit, CheckoutState>(
            listener: (context, state) {
              if (state is CheckoutSuccess) {
                CustomSnakeBar(context, "Order placed! ID: ${state.orderId}");

                context.read<CartCubit>().clearCart();

                final paymentCubit = context.read<PaymentCubit>();

                // تفعيل الـ loading
                isPaymentLoading.value = true;

                paymentCubit.startPayment(state.orderId.toString());
              }

              if (state is CheckoutFailure) {
                CustomSnakeBar(context, (state.errMessage));
              }
            },
            builder: (context, state) {
              if (state is CheckoutLoading) {
                return const CustomLoadingIndicator();
              }

              final cartItems = context.read<CartCubit>().state is CartSuccess
                  ? (context.read<CartCubit>().state as CartSuccess)
                        .cartItemsModel
                        .items!
                  : <CartModel>[];

              final total = cartItems.fold<double>(
                0,
                (sum, dynamic item) =>
                    sum +
                    double.tryParse((item.product!.price!))! * item.quantity!,
              );

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildAddressSection(context, selectedAddressId),
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final dynamic item = cartItems[index];
                          return ListTile(
                            leading: CustomCachedNetworkImage(
                              image:
                                  "https://uncondemnable-brianna-hazelly.ngrok-free.dev/${item.product?.image}" ??
                                  "",

                              // imageUrl:
                              //     "http://10.0.2.2:8000/${item.product?.image}" ??
                              //     "",
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(item.product!.title ?? ""),
                            subtitle: Text("Qty: ${item.quantity}"),
                            trailing: Text(
                              style: Theme.of(context).textTheme.bodySmall,
                              "\$${(double.tryParse(item.product!.price!)! * item.quantity!).toStringAsFixed(2)}",
                            ),
                          );
                        },
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total",
                            style: Theme.of(context).textTheme.titleLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "\$${total.toStringAsFixed(2)}",
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                          ),
                        ],
                      ),
                    ),
                    CustomButton(
                      isLoading: state is CheckoutLoading ? true : false,
                      text: "Place Order",
                      isDisable: cartItems.isEmpty,
                      onPressed: cartItems.isEmpty
                          ? () {}
                          : () {
                              context
                                  .read<BiometricsCubit>()
                                  .authenticateIfAvailable();

                              // context
                              //     .read<CheckoutCubit>()
                              //     .createCheckoutOrder();
                            },
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        // Loading overlay باستخدام ValueListenableBuilder
        ValueListenableBuilder<bool>(
          valueListenable: isPaymentLoading,
          builder: (context, loading, _) {
            if (!loading) return const SizedBox.shrink();
            return Container(
              color: Colors.black.withOpacity(0.3),
              child: const CustomLoadingIndicator(),
            );
          },
        ),
      ],
    );
  }
}

Widget _buildAddressSection(
  BuildContext context,
  ValueNotifier<int?> selectedAddressId,
) {
  final addressState = context.watch<AddressCubit>().state;
  final checkoutCubit = context.read<CheckoutCubit>();

  if (addressState is AddressLoading) {
    return const CustomLoadingIndicator();
  }

  if (addressState is AddressFailure) {
    return Text(
      addressState.errMessage,
      style: TextStyle(color: Theme.of(context).colorScheme.error),
    );
  }

  List<AddressResponse> addresses = [];
  if (addressState is AddressSuccess) {
    addresses = addressState.allAddresses;
  }

  // لو مفيش ولا عنوان
  if (addresses.isEmpty) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Shipping Address",
          style: Theme.of(
            context,
          ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text("No addresses found."),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () => context.push(AppRouter.kCustomerAddAddress),
          icon: Icon(Icons.add_location_alt),
          label: Text("Add Address"),
        ),
      ],
    );
  }

  // اختار الـ default address
  final defaultAddress = addresses.firstWhere(
    (e) => e.isDefault == true,
    orElse: () => addresses.first,
  );
  selectedAddressId.value ??= defaultAddress.id;

  checkoutCubit.selectedAddressId ??= defaultAddress.id;

  return ValueListenableBuilder<int?>(
    valueListenable: selectedAddressId,

    builder: (context, selectedId, _) {
      final currentAddress = addresses.firstWhere(
        (addr) => addr.id == selectedId,
        orElse: () => defaultAddress,
      );

      return Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Shipping Address",
              style: Theme.of(
                context,
              ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              // "${defaultAddress.street}, ${defaultAddress.city}, ${defaultAddress.governorate}",
              "${currentAddress.street}, ${currentAddress.city}, ${currentAddress.governorate}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 5),
            Text(currentAddress.country ?? "Egypt"),
            // Text(defaultAddress.country ?? "Egypt"),
            const SizedBox(height: 8),

            TextButton(
              onPressed: () =>
                  _openAddressSelector(context, addresses, selectedAddressId),
              child: Text(
                "Change Address",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      );
    },
  );
}

void _openAddressSelector(
  BuildContext context,
  List<AddressResponse> addresses,
  ValueNotifier<int?> selectedAddressId,
) {
  final checkoutCubit = context.read<CheckoutCubit>();
  // int? selected = checkoutCubit.selectedAddressId ?? addresses.first.id;
  // final ValueNotifier<int?> selectedAddressId = ValueNotifier(null);

  showModalBottomSheet(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ValueListenableBuilder<int?>(
            valueListenable: selectedAddressId,
            builder: (context, selectedId, _) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Choose Address",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),

                  ...addresses.map((addr) {
                    return RadioListTile<int>(
                      title: Text("${addr.street}, ${addr.city}"),
                      value: addr.id!,
                      groupValue: selectedAddressId.value,
                      onChanged: (val) {
                        selectedAddressId.value = val;

                        setState(() => selectedAddressId.value = val);

                        checkoutCubit.setSelectedAddress(val!);
                      },
                    );
                  }),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Confirm"),
                  ),
                ],
              );
            },
          ),
        );
      },
    ),
  );
}
