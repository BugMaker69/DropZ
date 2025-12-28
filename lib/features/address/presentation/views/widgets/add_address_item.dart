import 'package:drop_z_ecommerce_app/core/utils/Validators%20.dart';
import 'package:drop_z_ecommerce_app/core/utils/app_router.dart';
import 'package:drop_z_ecommerce_app/core/utils/service_locator.dart';
import 'package:drop_z_ecommerce_app/core/utils/styles.dart';
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
import 'package:drop_z_ecommerce_app/features/address/presentation/manager/add_address_cubit/add_address_cubit.dart';
import 'package:drop_z_ecommerce_app/features/address/presentation/manager/address_cubit/address_cubit.dart';
import 'package:drop_z_ecommerce_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddAddressItem extends StatefulWidget {
  const AddAddressItem({super.key});

  @override
  State<AddAddressItem> createState() => _AddAddressItemState();
}

class _AddAddressItemState extends State<AddAddressItem> {
  final streetController = TextEditingController();

  final postalCodeController = TextEditingController();

  final countries = [
    DropdownMenuItem<String>(value: 'Egypt', child: Text('Egypt')),
  ];

  List<Governorate> governorates = [];

  List<City> cities = [];

  List<City> filteredCities = [];

  String? country = "Egypt";

  Governorate? selectedGov;

  City? selectedCity;

  bool isActive = true;

  final addAddressFormKey = GlobalKey<FormState>();

  final ValueNotifier<bool> activeNotifier = ValueNotifier<bool>(true);

  Future<void> loadData() async {
    governorates = await AddressService.loadGovernorates();
    cities = await AddressService.loadCities();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: Text("${localizations.addNewAddress}")),
        body: BlocListener<AddAddressCubit, AddAddressState>(
          listener: (context, state) {
            if (state is AddAddressLoading) {
              CustomLoadingIndicator();
            }
            if (state is AddAddressFailure) {
              CustomSnakeBar(context, "Error: ${state.message}");
            }
            if (state is AddAddressSuccess) {
              context.go(AppRouter.kCustomerHome);
              CustomSnakeBar(context, "${localizations.addressAddedSuccess}");
            }
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Form(
              key: addAddressFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${localizations.addNewAddress}",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: buildDropdown<String>(
                          context: context,
                          label: "${localizations.chooseCountry}",
                          value: country,
                          items: countries,
                          onChanged: (c) {
                            setState(() => country = c);
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: buildDropdown<Governorate>(
                          context: context,
                          value: selectedGov,
                          label: "${localizations.chooseGovernorate}",
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
                          value: selectedCity,
                          label: "${localizations.chooseCity}",
                          validator: (value) => value == null
                              ? "${localizations.pleaseSelectCity}"
                              : null,
                          items: filteredCities
                              .map(
                                (c) => DropdownMenuItem(
                                  value: c,
                                  child: Text(
                                    c.nameEn,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (city) {
                            setState(() => selectedCity = city);
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  CustomTextEdit(
                    labelText: "${localizations.street}",
                    textController: streetController,
                    validator: (value) => Validators.validateRequired(
                      value,
                      "${localizations.street}",
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
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
                          SizedBox(width: 8),
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
                                onChanged: (val) {
                                  activeNotifier.value = val;
                                },
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
                  CustomButton(
                    isLoading:
                        context.read<AddAddressCubit>().state
                            is AddAddressLoading
                        ? true
                        : false,
                    text: "${localizations.addAddress}",
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      if (addAddressFormKey.currentState!.validate()) {
                        context.read<AddAddressCubit>().addAddress(
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
    );
  }
}
