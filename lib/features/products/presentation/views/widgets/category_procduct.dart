import 'package:drop_z_ecommerce_app/core/widgets/custom_error_widget.dart';
import 'package:drop_z_ecommerce_app/features/products/data/model/product_item_data_model/product_item_data_model.dart';
import 'package:flutter/material.dart';
import 'package:drop_z_ecommerce_app/features/products/presentation/views/widgets/product_items_list.dart';

class CategoryProductsView extends StatelessWidget {
  final int category;
  final ProductItemDataModel products;
  final int roleId;
  const CategoryProductsView({
    super.key,
    required this.category,
    required this.products,
    required this.roleId,
  });

  @override
  Widget build(BuildContext context) {
    final filteredProducts = category == 0
        ? products.results!
        : products.results!.where((p) => p.category == category).toList();

    if (filteredProducts.isEmpty) {//!
      return CustomErrorWidget(errMessage: "No products in $category category");
    }

    return ProductItemsList(filteredProducts: filteredProducts, roleId: roleId);
  }
}
