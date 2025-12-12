import 'package:drop_z_ecommerce_app/features/products/data/model/product_item_data_model/result.dart';
import 'package:drop_z_ecommerce_app/features/products/presentation/views/widgets/product_item.dart';
import 'package:drop_z_ecommerce_app/features/products/presentation/views/widgets/staggered_product_item.dart';
import 'package:flutter/material.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ProductItemsList extends StatelessWidget {
  final List<Result> filteredProducts;
  final int roleId;

  const ProductItemsList({
    super.key,
    required this.filteredProducts,
    required this.roleId,
  });

  @override
  Widget build(BuildContext context) {
    if (filteredProducts.isEmpty) {
      return const Center(child: Text("No products available"));
    }

    if (roleId == 0) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: StaggeredGrid.count(
          crossAxisCount: 4, // 2 عمود (كل منتج ياخد 2)
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: filteredProducts.asMap().entries.map((entry) {
            final index = entry.key;
            final product = entry.value;

            // طول عشوائي بين 220 و 320
            // final height = 240.0 + (index % 4) * 30.0;
            final height = 260.0 + (index % 5) * 30.0;

            return StaggeredGridTile.extent(
              crossAxisCellCount: 2,
              mainAxisExtent: height, // الأهم: extent يضمن الطول بالضبط
              child: StaggeredProductItem(product: product, height: height),
            );
          }).toList(),

          //   return StaggeredGridTile.count(
          //     crossAxisCellCount: 2, // كل منتج ياخد عمودين
          //     mainAxisCellCount: height / 100, // حسب الطول
          //     child: StaggeredProductItem(product: product, height: height),
          //   );
          // }).toList(),
        ),
      );
    } else {
      return ListView.builder(
        itemBuilder: (context, index) =>
            ProductItem(filteredProduct: filteredProducts[index]),
        itemCount: filteredProducts.length,
      );
    }
  }
}

/*
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
*/

/*
class ProductItemsList extends StatelessWidget {
  final List<Result> filteredProducts;

  const ProductItemsList({super.key, required this.filteredProducts});

  @override
  Widget build(BuildContext context) {
    if (filteredProducts.isEmpty) {
      return const Center(child: Text("No products"));
    }

    return StaggeredGrid.count(
      crossAxisCount: 4, // 2 عمود
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: filteredProducts.asMap().entries.map((entry) {
        final index = entry.key;
        final product = entry.value;

        // طول عشوائي (مثال: 200-300)
        final height = 220 + (index % 3) * 40.0;

        return StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: height / 100, // حسب الطول
          child: ProductItem(
            filteredProduct: product,
            height: height,
          ),
        );
      }).toList(),
    );
  }
}
*/
