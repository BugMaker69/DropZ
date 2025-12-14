import 'package:drop_z_ecommerce_app/core/widgets/custom_error_widget.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_loading_indicator.dart';
import 'package:drop_z_ecommerce_app/features/products/presentation/manager/products_cubit/products_cubit.dart';
import 'package:drop_z_ecommerce_app/features/products/presentation/views/widgets/category_procduct.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SellerDashboard extends StatelessWidget {
  const SellerDashboard({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        if (state is ProductsLoading) {
          return const CustomLoadingIndicator();
        } else if (state is ProductsFailure) {
          return CustomErrorWidget(errMessage: 'Error: ${state.errMessage}');
        } else if (state is ProductsDataState &&
            (state.products != null || state.products!.results!.isNotEmpty)) {
          return CategoryProductsView(
            category: 0,
            products: state.products!,
            roleId: 1,
          );
        }
        if (state is ProductsDataState && state.products != null) {
          return const CustomErrorWidget(errMessage: "No products available");
        }
        return const CustomLoadingIndicator();
      },
    );
  }
}
