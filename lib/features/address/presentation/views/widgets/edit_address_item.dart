import 'package:drop_z_ecommerce_app/constants.dart';
import 'package:drop_z_ecommerce_app/core/utils/Validators%20.dart';
import 'package:drop_z_ecommerce_app/core/utils/app_router.dart';
import 'package:drop_z_ecommerce_app/core/utils/service_locator.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_button.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_dropdown_button_form_field.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_edit_text.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_loading_indicator.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_snakebar_message.dart';
import 'package:drop_z_ecommerce_app/features/address/data/address_service.dart';
import 'package:drop_z_ecommerce_app/features/address/data/model/city.dart';
import 'package:drop_z_ecommerce_app/features/address/data/model/governorate.dart';
import 'package:drop_z_ecommerce_app/features/address/data/repos/address_repo_imp.dart';
import 'package:drop_z_ecommerce_app/features/address/domain/entities/address_entity.dart';
import 'package:drop_z_ecommerce_app/features/address/presentation/manager/address_cubit/address_cubit.dart';
import 'package:drop_z_ecommerce_app/features/address/presentation/manager/edit_address_cubit/edit_address_cubit.dart';
import 'package:drop_z_ecommerce_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EditAddressItem extends StatefulWidget {
  final AddressEntity? addressResponse;

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
    final localizations = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (_) => EditAddressCubit(getIt.get<AddressRepoImp>()),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(title: Text("${localizations.editAddress}")),
          body: BlocListener<EditAddressCubit, EditAddressState>(
            listener: (context, state) {
              if (state is EditAddressLoading) {
                CustomLoadingIndicator();
              }
              if (state is EditAddressFailure) {
                CustomSnakeBar(context, "Error: ${state.message}");
              }
              if (state is EditAddressSuccess) {
                context.go(AppRouter.kCustomerHome);
                CustomSnakeBar(
                  context,
                  "${localizations.addressUpdatedSuccess}",
                );
              }
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: editAddressFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${localizations.editAddress}",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(height: 16),

                    // Country Dropdown
                    buildDropdown<String>(
                      context: context,
                      label: "${localizations.chooseCountry}",
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
                            label: "${localizations.chooseGovernorate}",
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
                            label: "${localizations.chooseCity}",
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
                            validator: (value) => value == null
                                ? "${localizations.pleaseSelectCity}"
                                : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Street
                    CustomTextEdit(
                      labelText: "${localizations.street}",
                      textController: streetController,
                      validator: (value) => Validators.validateRequired(
                        value,
                        "${localizations.street}",
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Postal + Default Switch
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextEdit(
                            labelText: "${localizations.postalCode}",
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
                              "${localizations.setDefault}",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(width: 4),
                            ValueListenableBuilder<bool>(
                              valueListenable: activeNotifier,
                              builder: (context, value, _) {
                                return Switch(
                                  value: value,
                                  onChanged: (val) =>
                                      activeNotifier.value = val,
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
                      isLoading:
                          context.read<EditAddressCubit>().state
                              is EditAddressLoading
                          ? true
                          : false,
                      text: "${localizations.editAddress}",
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (editAddressFormKey.currentState!.validate()) {
                          context.read<EditAddressCubit>().updateAddress(
                            widget.addressResponse!.id!,
                            AddressEntity(
                              city: selectedCity!.nameEn,
                              country: country!,
                              governorate: selectedGov!.nameEn,
                              isDefault: activeNotifier.value,
                              postalCode: postalCodeController.text,
                              street: streetController.text,
                            ),
                          );
                          setState(() {});
                          // GoRouter.of(context).go(AppRouter.kCustomerHome);
                          // CustomSnakeBar(
                          //   context,
                          //   "✅ Address validated successfully",
                          // );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
