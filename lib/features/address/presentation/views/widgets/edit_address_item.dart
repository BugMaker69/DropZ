import 'package:drop_z_ecommerce_app/constants.dart';
import 'package:drop_z_ecommerce_app/core/utils/Validators%20.dart';
import 'package:drop_z_ecommerce_app/core/utils/app_router.dart';
import 'package:drop_z_ecommerce_app/core/utils/styles.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_button.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_edit_text.dart';
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

  final editAddressFormKey = GlobalKey<FormState>();

  final ValueNotifier<bool> activeNotifier = ValueNotifier<bool>(true);

  Future<void> loadData() async {
    governorates = await AddressService.loadGovernorates();
    cities = await AddressService.loadCities();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadData().then((_) {
      if (widget.addressResponse != null) {
        streetController.text = widget.addressResponse!.street!;
        postalCodeController.text = widget.addressResponse!.postalCode
            .toString();
        country = widget.addressResponse!.country;

        /// حدد المحافظة
        // selectedGov = governorates.firstWhere(
        //   (g) => g.nameEn == widget.addressResponse!.governorate,
        // );

        selectedGov = governorates.firstWhere(
          (g) =>
              g.nameEn.toLowerCase() ==
              widget.addressResponse!.governorate!.toLowerCase(),
          orElse: () =>
              Governorate(id: -1, nameEn: "Unknown", nameAr: ""), // fallback
        );

        if (selectedGov!.id == -1) {
          selectedGov = null; // معناها مش لاقي المحافظة
        }

        /// فلتر المدن
        filteredCities = cities
            .where((c) => c.governorateId == selectedGov!.id)
            .toList();

        /// حدد المدينة
        // selectedCity = filteredCities.firstWhere(
        //   (c) => c.nameEn == widget.addressResponse!.city,
        // );

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

        activeNotifier.value = widget.addressResponse!.isDefault!;

        print(
          "${streetController.text},  ${postalCodeController.text} , ${country} ,   ${selectedGov} , ${selectedCity}  , ${activeNotifier.value} ",
        );
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: Text("Edit Address")),
        backgroundColor: kPrimaryColor,
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Form(
            key: editAddressFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Edit Address", style: Styles.textStyle45Bold),
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
