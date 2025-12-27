import 'package:drop_z_ecommerce_app/constants.dart';
import 'package:drop_z_ecommerce_app/core/utils/Validators%20.dart';
import 'package:drop_z_ecommerce_app/core/utils/app_router.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_button.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_dropdown_button_form_field.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_edit_text.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_snakebar_message.dart';
import 'package:drop_z_ecommerce_app/features/address/data/address_service.dart';
import 'package:drop_z_ecommerce_app/features/address/data/model/address_request.dart';
import 'package:drop_z_ecommerce_app/features/address/data/model/address_response/address_response.dart';
import 'package:drop_z_ecommerce_app/features/address/data/model/city.dart';
import 'package:drop_z_ecommerce_app/features/address/data/model/governorate.dart';
import 'package:drop_z_ecommerce_app/features/address/presentation/manager/address_cubit/address_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EditAddressItem extends StatefulWidget {
  final AddressResponse? addressResponse;

  const EditAddressItem({super.key, this.addressResponse});

  @override
  State<EditAddressItem> createState() => _EditAddressItemState();
}

class _EditAddressItemState extends State<EditAddressItem> {
  final streetController = TextEditingController();
  final postalCodeController = TextEditingController();

  String? country = "Egypt";
  Governorate? selectedGov;
  City? selectedCity;

  List<Governorate> governorates = [];
  List<City> cities = [];
  List<City> filteredCities = [];

  final editAddressFormKey = GlobalKey<FormState>();
  final ValueNotifier<bool> activeNotifier = ValueNotifier<bool>(true);

  final countries = [
    const DropdownMenuItem<String>(value: 'Egypt', child: Text('Egypt')),
  ];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    governorates = await AddressService.loadGovernorates();
    cities = await AddressService.loadCities();

    // Initialize fields if editing existing address
    final address = widget.addressResponse;
    if (address != null) {
      streetController.text = address.street ?? '';
      postalCodeController.text = address.postalCode ?? '';
      country = address.country ?? "Egypt";

      selectedGov = governorates.firstWhere(
        (g) => g.nameEn.toLowerCase() == address.governorate!.toLowerCase(),
        orElse: () => Governorate(id: -1, nameEn: "Unknown", nameAr: ""),
      );
      if (selectedGov!.id == -1) selectedGov = null;

      filteredCities = cities
          .where((c) => c.governorateId == selectedGov?.id)
          .toList();

      selectedCity = filteredCities.firstWhere(
        (c) =>
            c.nameEn.toLowerCase() ==
            widget.addressResponse!.city!.toLowerCase(),
        orElse: () =>
            City(id: -1, nameEn: "Unknown", governorateId: -1, nameAr: ""),
      );

      if (selectedCity!.id == -1) {
        selectedCity = null;
      }

      activeNotifier.value = address.isDefault!;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Edit Address")),
        // backgroundColor: kPrimaryColor,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: editAddressFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Edit Address",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: 16),

                // Country Dropdown
                buildDropdown<String>(
                  context: context,
                  label: "Choose Country",
                  value: country,
                  items: countries,
                  onChanged: (c) => setState(() => country = c),
                ),
                const SizedBox(height: 16),

                // Governorate + City Dropdowns
                Row(
                  children: [
                    Expanded(
                      child: buildDropdown<Governorate>(
                        context: context,
                        label: "Choose Governorate",
                        value: selectedGov,
                        items: governorates
                            .map(
                              (g) => DropdownMenuItem(
                                value: g,
                                child: Text(g.nameEn),
                              ),
                            )
                            .toList(),
                        onChanged: (gov) {
                          setState(() {
                            selectedGov = gov;
                            filteredCities = cities
                                .where((c) => c.governorateId == gov!.id)
                                .toList();
                            selectedCity = null;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: buildDropdown<City>(
                        context: context,
                        label: "Choose City",
                        value: selectedCity,
                        items: filteredCities
                            .map(
                              (c) => DropdownMenuItem(
                                value: c,
                                child: Text(
                                  c.nameEn,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (city) =>
                            setState(() => selectedCity = city),
                        validator: (value) =>
                            value == null ? "Please select a City" : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Street
                CustomTextEdit(
                  labelText: "Street",
                  textController: streetController,
                  validator: (value) =>
                      Validators.validateRequired(value, "Street"),
                ),
                const SizedBox(height: 16),

                // Postal + Default Switch
                Row(
                  children: [
                    Expanded(
                      child: CustomTextEdit(
                        labelText: "Postal Code",
                        textController: postalCodeController,
                        validator: Validators.validatePostalCode,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: [
                        const SizedBox(width: 8),
                        Text(
                          "Set Default",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(width: 4),
                        ValueListenableBuilder<bool>(
                          valueListenable: activeNotifier,
                          builder: (context, value, _) {
                            return Switch(
                              value: value,
                              onChanged: (val) => activeNotifier.value = val,
                              activeThumbColor: Theme.of(
                                context,
                              ).colorScheme.tertiary,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Submit Button
                CustomButton(
                  text: "Edit Address",
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    if (editAddressFormKey.currentState!.validate()) {
                      context.read<AddressCubit>().updateAddress(
                        widget.addressResponse!.id!,
                        AddressRequest(
                          city: selectedCity!.nameEn,
                          country: country,
                          governorate: selectedGov!.nameEn,
                          isDefault: activeNotifier.value,
                          postalCode: postalCodeController.text,
                          street: streetController.text,
                        ),
                      );
                      GoRouter.of(context).go(AppRouter.kCustomerHome);
                      CustomSnakeBar(
                        context,
                        "✅ Address validated successfully",
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper for Dropdowns
}
