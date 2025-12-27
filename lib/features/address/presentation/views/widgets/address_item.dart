import 'package:drop_z_ecommerce_app/core/utils/app_router.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_snakebar_message.dart';
import 'package:drop_z_ecommerce_app/features/address/domain/entities/address_entity.dart';
import 'package:drop_z_ecommerce_app/features/address/presentation/manager/address_cubit/address_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddressItem extends StatelessWidget {
  final AddressEntity addressResponse;
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
                      context.go(AppRouter.kCustomerHome);
                      CustomSnakeBar(context, "✅ Address Deleted successfully");
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
