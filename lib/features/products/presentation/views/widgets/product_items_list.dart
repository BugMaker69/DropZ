import 'package:drop_z_ecommerce_app/core/widgets/custom_error_widget.dart';
import 'package:drop_z_ecommerce_app/features/products/data/model/product_item_data_model/result.dart';
import 'package:drop_z_ecommerce_app/features/products/presentation/manager/products_cubit/products_cubit.dart';
import 'package:drop_z_ecommerce_app/features/products/presentation/views/widgets/product_item.dart';
import 'package:drop_z_ecommerce_app/features/products/presentation/views/widgets/staggered_product_item.dart';
import 'package:drop_z_ecommerce_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      return CustomErrorWidget(
        errMessage: "${AppLocalizations.of(context)!.noDataAvailable}",
      );
    }

    if (roleId == 0) {
      return RefreshIndicator(
        onRefresh: () => context.read<ProductsCubit>().refreshAllData(),
        child: SingleChildScrollView(
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
          ),
        ),
      );
    } else {
      return RefreshIndicator(
        onRefresh: () => context.read<ProductsCubit>().getAllSellerProducts(),
        child: ListView.builder(
          itemBuilder: (context, index) =>
              ProductItem(filteredProduct: filteredProducts[index]),
          itemCount: filteredProducts.length,
        ),
      );
    }
  }
}
