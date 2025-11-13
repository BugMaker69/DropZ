import 'dart:io';

import 'package:drop_z_ecommerce_app/constants.dart';
import 'package:drop_z_ecommerce_app/core/utils/Validators%20.dart';
import 'package:drop_z_ecommerce_app/core/utils/app_router.dart';
import 'package:drop_z_ecommerce_app/core/utils/styles.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_button.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_edit_text.dart';
import 'package:drop_z_ecommerce_app/features/products/data/model/add_product_request.dart';
import 'package:drop_z_ecommerce_app/features/products/data/model/category_model/category_model.dart';
import 'package:drop_z_ecommerce_app/features/products/presentation/manager/products_cubit/products_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class AddProductItem extends StatelessWidget {
  final List<CategoryModel> categories;
  AddProductItem({super.key, required this.categories});

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final stockQuantityController = TextEditingController();
  final categoryController = TextEditingController();
  // final isActiveController = TextEditingController();
  bool isActive = true;

  final addProductFormKey = GlobalKey<FormState>();

  final ValueNotifier<File?> selectedImage = ValueNotifier<File?>(null);
  final ValueNotifier<String?> selectedCategory = ValueNotifier<String?>(null);
  final ValueNotifier<bool> activeNotifier = ValueNotifier<bool>(true);

  int? selectedCategoryId;

  // final _userRole = [
  //   DropdownMenuItem<String>(value: 'customer', child: Text('Customer')),
  //   DropdownMenuItem<String>(value: 'seller', child: Text('Seller')),
  //   DropdownMenuItem<String>(
  //     value: 'shipping_company',
  //     child: Text('Shipping Company'),
  //   ),
  // ];
  // String _selectedRole = "customer";

  final ImagePicker picker = ImagePicker();

  Future<void> pickImage(BuildContext context) async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  // Future<void> pickImage(ImageSource source) async {
  //   final pickedFile = await picker.pickImage(source: source, imageQuality: 85);
  //   if (pickedFile != null) {
  //     selectedImage.value = File(pickedFile.path);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: kPrimaryColor,
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Form(
              key: addProductFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Add New Product", style: Styles.textStyle45Bold),
                  const SizedBox(height: 16),

                  CustomTextEdit(
                    labelText: "Title",
                    textController: titleController,
                    validator: (value) =>
                        Validators.validateRequired(value, "Title"),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomTextEdit(
                          labelText: "Price",
                          textController: priceController,
                          validator: Validators.validatePrice,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomTextEdit(
                          labelText: "StockQuantity",
                          textController: stockQuantityController,
                          validator: Validators.validateStock,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      //! DropDown Menu Come From API then Map to Vlaues
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          dropdownColor: kPrimaryColor,
                          style: Styles.textStyle18Regular.copyWith(
                            color: Colors.white,
                          ),
                          iconEnabledColor: Colors.white,
                          items: categories
                              .map(
                                (cat) => DropdownMenuItem<int>(
                                  value: cat.id,
                                  child: Text(cat.name!),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            selectedCategoryId = value;
                          },
                          validator: (value) =>
                              value == null ? "Please select a category" : null,
                          initialValue: selectedCategoryId,
                          decoration: InputDecoration(
                            labelText: "Select Category",
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

                      // const SizedBox(width: 16),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 8),
                      Text(
                        "Active",
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

                  const SizedBox(height: 16),
                  ValueListenableBuilder<File?>(
                    valueListenable: selectedImage,
                    builder: (context, image, _) {
                      return InkWell(
                        onTap: () => pickImage(context),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: 160,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: image != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    image,
                                    fit: BoxFit.scaleDown,
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.image_outlined,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "Tap to select an image",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  CustomTextEdit(
                    labelText: "Description",
                    textController: descriptionController,
                    validator: (value) =>
                        Validators.validateRequired(value, "Description"),
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                  ),

                  // Make It Image Picker and replace it with description
                  const SizedBox(height: 16),
                  CustomButton(
                    text: "Add Product",
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      if (addProductFormKey.currentState!.validate()) {
                        final image = selectedImage.value;
                        if (image == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("⚠️ Please select a product image"),
                            ),
                          );
                          return;
                        }

                        context.read<ProductsCubit>().addProductItem(
                          AddProductRequest(
                            title: titleController.text,
                            description: descriptionController.text,
                            price: double.parse(priceController.text),
                            stockQuantity: int.parse(
                              stockQuantityController.text,
                            ),
                            imageFile: selectedImage.value,
                            isActive: activeNotifier.value,
                            category: selectedCategoryId,
                          ),
                        );
                        GoRouter.of(context).go(AppRouter.kHomeView);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("✅ Product validated successfully"),
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
      ),
    );
  }
}
