import 'package:drop_z_ecommerce_app/features/products/data/model/category_model/category_model.dart';
import 'package:drop_z_ecommerce_app/features/products/presentation/views/widgets/add_product_item.dart';
import 'package:flutter/material.dart';

class AddProductView extends StatelessWidget {
  final List<CategoryModel> categories;
  const AddProductView({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return AddProductItem(categories: categories);
  }
}
