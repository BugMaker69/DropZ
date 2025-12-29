import 'dart:io';

import 'package:drop_z_ecommerce_app/constants.dart';
import 'package:drop_z_ecommerce_app/core/utils/Validators%20.dart';
import 'package:drop_z_ecommerce_app/core/utils/app_router.dart';
import 'package:drop_z_ecommerce_app/core/utils/styles.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_button.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_dropdown_button_form_field.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_edit_text.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_snakebar_message.dart';
import 'package:drop_z_ecommerce_app/features/products/data/model/add_product_request.dart';
import 'package:drop_z_ecommerce_app/features/products/data/model/category_model/category_model.dart';
import 'package:drop_z_ecommerce_app/features/products/presentation/manager/products_cubit/products_cubit.dart';
import 'package:drop_z_ecommerce_app/l10n/app_localizations.dart';
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

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Form(
              key: addProductFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    //!
                    "Add New Product",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(height: 16),

                  CustomTextEdit(
                    labelText: "${localizations.title}",
                    textController: titleController,
                    validator: (value) => Validators.validateRequired(
                      value,
                      "${localizations.title}",
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomTextEdit(
                          labelText: "${localizations.price}",
                          textController: priceController,
                          validator: Validators.validatePrice,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomTextEdit(
                          labelText: "${localizations.stockQuantity}",
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
                      Expanded(
                        child: buildDropdown<int>(
                          context: context,
                          value: selectedCategoryId,
                          label: "${localizations.selectCategory}",
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
                          validator: (value) => value == null
                              ? "${localizations.pleaseSelectCategory}"
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      SizedBox(width: 8),
                      Text(
                        "${localizations.active}",
                        style: Theme.of(context).textTheme.bodyMedium,
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
                            activeThumbColor: Theme.of(
                              context,
                            ).colorScheme.tertiary,
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
                            color: Theme.of(context).colorScheme.onPrimary,
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
                                  children: [
                                    Icon(
                                      Icons.image_outlined,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "${localizations.tapToSelectImage}",
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
                    labelText: "${localizations.description}",
                    textController: descriptionController,
                    validator: (value) => Validators.validateRequired(
                      value,
                      "${localizations.description}",
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    //!
                    text: "Add Product",
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      if (addProductFormKey.currentState!.validate()) {
                        final image = selectedImage.value;
                        if (image == null) {
                          CustomSnakeBar(
                            context,
                            "${localizations.selectProductImageWarning}",
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
                        GoRouter.of(context).go(AppRouter.kSellerDashboard);

                        CustomSnakeBar(
                          context,
                          "${localizations.productValidated}",
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
