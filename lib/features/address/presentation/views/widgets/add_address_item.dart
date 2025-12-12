import 'package:drop_z_ecommerce_app/constants.dart';
import 'package:drop_z_ecommerce_app/core/utils/Validators%20.dart';
import 'package:drop_z_ecommerce_app/core/utils/app_router.dart';
import 'package:drop_z_ecommerce_app/core/utils/styles.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_button.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_edit_text.dart';
import 'package:drop_z_ecommerce_app/features/address/data/address_service.dart';
import 'package:drop_z_ecommerce_app/features/address/data/model/address_request.dart';
import 'package:drop_z_ecommerce_app/features/address/data/model/city.dart';
import 'package:drop_z_ecommerce_app/features/address/data/model/governorate.dart';
import 'package:drop_z_ecommerce_app/features/address/presentation/manager/address_cubit/address_cubit.dart';
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: Text("Add New Address")),
        backgroundColor: kPrimaryColor,
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Form(
            key: addAddressFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Add New Address", style: Styles.textStyle45Bold),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        dropdownColor: kPrimaryColor,
                        style: Styles.textStyle18Regular.copyWith(
                          color: Colors.white,
                        ),
                        iconEnabledColor: Colors.white,
                        initialValue: country,
                        items: countries,
                        onChanged: (c) {
                          setState(() => country = c);
                        },
                        decoration: InputDecoration(
                          labelText: "Choose Country",
                          // labelText: "اختر الدولة",
                          labelStyle: Styles.textStyle18Regular.copyWith(
                            color: Colors.white,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(
                              color: Colors.white70,
                              width: 2,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(
                              color: Colors.white70,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(
                              color: Colors.white70,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<Governorate>(
                        initialValue: selectedGov,
                        dropdownColor: kPrimaryColor,
                        style: Styles.textStyle18Regular.copyWith(
                          color: Colors.white,
                        ),
                        iconEnabledColor: Colors.white,
                        // value: selectedGov,
                        decoration: InputDecoration(
                          labelText: "Choose Governorate",
                          // labelText: "اختر المحافظة",
                          labelStyle: Styles.textStyle18Regular.copyWith(
                            color: Colors.white,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(
                              color: Colors.white70,
                              width: 2,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(
                              color: Colors.white70,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(
                              color: Colors.white70,
                              width: 2,
                            ),
                          ),
                        ),
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
                            print(gov);
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
                      child: DropdownButtonFormField<City>(
                        dropdownColor: kPrimaryColor,
                        style: Styles.textStyle18Regular.copyWith(
                          color: Colors.white,
                        ),
                        isExpanded: true,
                        iconEnabledColor: Colors.white,
                        value: selectedCity,
                        decoration: InputDecoration(
                          labelText: "Choose City",
                          // labelText: "اختر المدينة",
                          labelStyle: Styles.textStyle18Regular.copyWith(
                            color: Colors.white,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(
                              color: Colors.white70,
                              width: 2,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(
                              color: Colors.white70,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(
                              color: Colors.white70,
                              width: 2,
                            ),
                          ),
                        ),

                        validator: (value) =>
                            value == null ? "Please select a City" : null,
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
                          print(city);

                          setState(() => selectedCity = city);
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                CustomTextEdit(
                  labelText: "Street",
                  textController: streetController,
                  validator: (value) =>
                      Validators.validateRequired(value, "Street"),
                ),
                const SizedBox(height: 16),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomTextEdit(
                        labelText: "Postal Code",
                        textController: postalCodeController,
                        validator: Validators.validatePostalCode,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Row(
                        children: [
                          SizedBox(width: 8),
                          Text(
                            "Set Default",
                            style: Styles.textStyle18Regular.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 16),
                          ValueListenableBuilder<bool>(
                            valueListenable: activeNotifier,
                            builder: (context, value, _) {
                              return Switch(
                                value: value,
                                onChanged: (val) {
                                  activeNotifier.value = val;
                                },
                                activeThumbColor: Colors.green,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                CustomButton(
                  text: "Add Address",
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    if (addAddressFormKey.currentState!.validate()) {
                      context.read<AddressCubit>().addAddress(
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

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("✅ Address validated successfully"),
                        ),
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
}
