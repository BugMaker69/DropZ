import 'package:drop_z_ecommerce_app/features/products/data/model/product_item_data_model/result.dart';
import 'package:drop_z_ecommerce_app/features/products/presentation/views/widgets/product_item.dart';
import 'package:flutter/material.dart';

class ProductItemsList extends StatelessWidget {
  ProductItemsList({super.key, required this.filteredProducts});
  final List<Result> filteredProducts;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) =>
          ProductItem(filteredProduct: filteredProducts[index]),
      // separatorBuilder: (context, index) => SizedBox(width: 30),
      scrollDirection: Axis.horizontal,
      itemCount: filteredProducts.length,
    );
    // CustomScrollView(
    //   slivers: [
    //     SliverToBoxAdapter()
    //   ],
    // );
  }
}
