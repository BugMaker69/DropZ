import 'package:drop_z_ecommerce_app/core/utils/app_router.dart';
import 'package:drop_z_ecommerce_app/features/address/data/model/address_response/address_response.dart';
import 'package:drop_z_ecommerce_app/features/address/presentation/manager/address_cubit/address_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddressItem extends StatelessWidget {
  final AddressResponse addressResponse;
  const AddressItem({super.key, required this.addressResponse});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        GoRouter.of(
          context,
        ).push(AppRouter.kCustomerEditAddress, extra: addressResponse);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colors.shadow.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Country + Default Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    addressResponse.country ?? '',
                    style: theme.textTheme.titleMedium!.copyWith(
                      color: colors.onSurface,
                    ),
                  ),

                  /// Default Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: addressResponse.isDefault!
                          ? colors.tertiary
                          : colors.outlineVariant,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          addressResponse.isDefault!
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          size: 16,
                          color: colors.onPrimary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          addressResponse.isDefault!
                              ? "Default"
                              : "Not Default",
                          style: theme.textTheme.bodySmall!.copyWith(
                            color: colors.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              /// Address Info
              Wrap(
                runSpacing: 10,
                spacing: 16,
                children: [
                  _infoItem(
                    context,
                    Icons.location_on,
                    "Governorate",
                    addressResponse.governorate,
                  ),
                  _infoItem(
                    context,
                    Icons.location_city,
                    "City",
                    addressResponse.city,
                  ),
                  _infoItem(
                    context,
                    Icons.streetview,
                    "Street",
                    addressResponse.street,
                  ),
                  _infoItem(
                    context,
                    Icons.markunread_mailbox,
                    "Postal",
                    addressResponse.postalCode,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  /// Delete
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<AddressCubit>().deleteAddress(
                        addressResponse.id!,
                      );
                    },
                    icon: const Icon(Icons.delete, size: 18),
                    label: const Text("حذف"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.error,
                      foregroundColor: colors.onError,
                    ),
                  ),
                  const SizedBox(width: 12),

                  /// Edit
                  ElevatedButton.icon(
                    onPressed: () {
                      GoRouter.of(context).push(
                        AppRouter.kCustomerEditAddress,
                        extra: addressResponse,
                      );
                    },
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text("تعديل"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.tertiaryFixed,
                      foregroundColor: colors.onPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoItem(
    BuildContext context,
    IconData icon,
    String label,
    String? value,
  ) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: colors.onSurface),
        const SizedBox(width: 6),
        Text(
          "$label: ",
          style: theme.textTheme.bodySmall!.copyWith(
            fontWeight: FontWeight.w600,
            color: colors.onSurface,
          ),
        ),
        Text(
          value ?? '',
          style: theme.textTheme.bodySmall!.copyWith(
            color: colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}


/*
class AddressItem extends StatelessWidget {
  final AddressResponse addressResponse;
  const AddressItem({super.key, required this.addressResponse});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(
          context,
        ).push(AppRouter.kCustomerEditAddress, extra: addressResponse);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          // gradient: LinearGradient(
          //   colors: [Colors.white, Colors.grey.shade100],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Country + Default Badge Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        addressResponse.country ?? '',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: addressResponse.isDefault!
                              ? Colors.green
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              addressResponse.isDefault!
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              size: 16,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              addressResponse.isDefault!
                                  ? "Default"
                                  : "Not Default",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Details Grid with Icons
                  Wrap(
                    runSpacing: 8,
                    spacing: 16,
                    children: [
                      _infoItem(
                        Icons.location_on,
                        "Governorate",
                        addressResponse.governorate,
                      ),
                      _infoItem(
                        Icons.location_city,
                        "City",
                        addressResponse.city,
                      ),
                      _infoItem(
                        Icons.streetview,
                        "Street",
                        addressResponse.street,
                      ),
                      _infoItem(
                        Icons.markunread_mailbox,
                        "Postal",
                        addressResponse.postalCode,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  // Action Buttons Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<AddressCubit>().deleteAddress(
                            addressResponse.id!,
                          );
                        },
                        icon: const Icon(Icons.delete, size: 18),
                        label:  Text("حذف"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:Theme.of(context).colorScheme.error,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          GoRouter.of(context).push(
                            AppRouter.kCustomerEditAddress,
                            extra: addressResponse,
                          );
                        },
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text("تعديل"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:Theme.of(context).colorScheme.tertiaryFixed,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoItem(IconData icon, String label, String? value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey[700]),
        const SizedBox(width: 4),
        Text("$label: ", style: const TextStyle(fontWeight: FontWeight.w600,color: Colors.black)),
        Text(value ?? '', style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

*/



/*
class AddressItem extends StatelessWidget {
  final AddressResponse addressResponse;
  const AddressItem({super.key, required this.addressResponse});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(
          context,
        ).push(AppRouter.kCustomerEditAddress, extra: addressResponse);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Country + Default Badge
              Row(
                children: [
                  Expanded(
                    child: Text(
                      addressResponse.country ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: addressResponse.isDefault!
                          ? Colors.green
                          : Colors.grey[400],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          addressResponse.isDefault!
                              ? Icons.check
                              : Icons.close,
                          color: Colors.white,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          addressResponse.isDefault!
                              ? "Default"
                              : "Not Default",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Details Grid
              Wrap(
                runSpacing: 6,
                spacing: 12,
                children: [
                  _infoItem("Governorate", addressResponse.governorate),
                  _infoItem("City", addressResponse.city),
                  _infoItem("Street", addressResponse.street),
                  _infoItem("Postal Code", addressResponse.postalCode),
                ],
              ),

              const SizedBox(height: 12),
              // Delete button
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.read<AddressCubit>().deleteAddress(
                      addressResponse.id!,
                    );
                  },
                  icon: const Icon(Icons.delete, size: 18),
                  label: const Text("حذف"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper for details
  Widget _infoItem(String label, String? value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "$label: ",
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        Text(value ?? '', style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
*/

/*
class AddressItem extends StatelessWidget {
  final AddressResponse addressResponse;
  const AddressItem({super.key, required this.addressResponse});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(
          context,
        ).push(AppRouter.kCustomerEditAddress, extra: addressResponse);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text("Country: "),
                  Text("${addressResponse.country}"),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: addressResponse.isDefault!
                              ? Colors.green
                              : Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          addressResponse.isDefault!
                              ? "Default"
                              : "Not Default",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8),
              Row(
                children: [
                  Text("Government: "),
                  Text("${addressResponse.governorate}"),
                ],
              ),
              SizedBox(height: 8),

              Row(children: [Text("City: "), Text("${addressResponse.city}")]),

              SizedBox(height: 8),
              Row(
                children: [Text("Street: "), Text("${addressResponse.street}")],
              ),

              SizedBox(height: 8),
              Row(
                children: [
                  Text("Postal Code: "),
                  Text("${addressResponse.postalCode}"),
                ],
              ),

              SizedBox(height: 8),
              Row(
                children: [
                  // Text("Is Default: "),
                  // Text(
                  //   addressResponse.isDefault! ? "Yes" : "No",
                  //   style: TextStyle(
                  //     color: addressResponse.isDefault!
                  //         ? Colors.greenAccent
                  //         : Colors.redAccent,
                  //   ),
                  // ),
                  Expanded(
                    child: Align(
                      alignment: AlignmentGeometry.bottomRight,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.read<AddressCubit>().deleteAddress(
                            addressResponse.id!,
                          );
                        },
                        icon: const Icon(Icons.delete, size: 18),
                        label: const Text("حذف"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
