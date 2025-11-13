import 'package:drop_z_ecommerce_app/features/products/data/model/product_item_data_model/product_item_data_model.dart';
import 'package:flutter/material.dart';
import 'package:drop_z_ecommerce_app/features/products/presentation/views/widgets/product_items_list.dart';

class CategoryProductsView extends StatelessWidget {
  final int category;
  final ProductItemDataModel products;
  const CategoryProductsView({
    super.key,
    required this.category,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    final filteredProducts = category == 0
        ? products.results!
        : products.results!.where((p) => p.category == category).toList();

    print("filteredProducts ${filteredProducts}");

    if (filteredProducts.isEmpty) {
      return Center(child: Text("No products in $category category"));
    }

    return ProductItemsList(filteredProducts: filteredProducts);
  }
}

/*
class CategoryProductsView extends StatelessWidget {
  final int category;
  const CategoryProductsView({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        if (state is ProductsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProductsFailure) {
          print("${state.errMessage}");
          return Center(child: Text(state.errMessage));
        } else if (state is ProductsDataState && state.products != null) {
          // فلترة المنتجات حسب الكاتيجوري

          final filteredProducts = category != 0
              ? state.products!.results!
                    .where((p) => p.category == category)
                    .toList()
              : state.products!.results!.toList();

          print("filteredProducts ${filteredProducts}");

          if (filteredProducts.isEmpty) {
            return Center(child: Text("No products in $category category"));
          }

          return ProductItemsList(filteredProducts: filteredProducts);
        } else {
          return const Center(child: Text("No data available"));
        }
      },
    );
  }
}
*/
