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
          ? const Center(child: Text("لا توجد منتجات"))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "المنتجات المطابقة",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 320,
                    child: ProductItemsList(filteredProducts: filteredProducts),
                  ),
                ],
              ),
            ),
    );
  }
}
