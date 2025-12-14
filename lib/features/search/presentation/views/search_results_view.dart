import 'package:drop_z_ecommerce_app/core/widgets/custom_error_widget.dart';
import 'package:drop_z_ecommerce_app/features/products/data/model/product_item_data_model/product_item_data_model.dart';
import 'package:drop_z_ecommerce_app/features/products/presentation/views/widgets/product_items_list.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchResultsView extends StatelessWidget {
  final String query;
  final ProductItemDataModel products;

  const SearchResultsView({
    super.key,
    required this.query,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    // final filteredProducts = products.results!
    //     .where((p) => p.title!.toLowerCase().contains(query.toLowerCase()))
    //     .toList();
    final queryWords = query.toLowerCase().split(' ');
    final filteredProducts = products.results!.where((p) {
      final titleLower = p.title!.toLowerCase();
      return queryWords.every((word) => titleLower.contains(word));
    }).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('نتائج البحث عن: "$query"'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: filteredProducts.isEmpty
          ? const CustomErrorWidget(errMessage: "لا توجد منتجات")
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "المنتجات المطابقة",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  ProductItemsList(
                    filteredProducts: filteredProducts,
                    roleId: 0,
                  ),
                ],
              ),
            ),
    );
  }
}
