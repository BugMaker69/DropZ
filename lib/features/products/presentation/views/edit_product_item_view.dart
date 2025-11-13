import 'package:drop_z_ecommerce_app/features/products/data/model/category_model/category_model.dart';
import 'package:drop_z_ecommerce_app/features/products/data/model/product_item_data_model/result.dart';
import 'package:drop_z_ecommerce_app/features/products/presentation/views/widgets/Edit_product_item.dart';
import 'package:flutter/material.dart';

class EditProductItemView extends StatelessWidget {
  final List<CategoryModel> categories;
  final Result product;

  const EditProductItemView({
    super.key,
    required this.categories,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return EditProductItem(categories: categories, product: product);
  }
}
