import 'package:drop_z_ecommerce_app/core/utils/service_locator.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_error_widget.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_loading_indicator.dart';
import 'package:drop_z_ecommerce_app/features/products/data/repos/products_repo_imp.dart';
import 'package:drop_z_ecommerce_app/features/products/presentation/manager/products_cubit/products_cubit.dart';
import 'package:drop_z_ecommerce_app/features/products/presentation/views/widgets/category_procduct.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SellerDashboard extends StatefulWidget {
  const SellerDashboard({super.key});

  @override
  State<SellerDashboard> createState() => _SellerDashboardState();
}

class _SellerDashboardState extends State<SellerDashboard> {
  @override
  void initState() {
    super.initState();
    context.read<ProductsCubit>().loadAllSellerData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        if (state is ProductsLoading) {
          return const CustomLoadingIndicator();
        } else if (state is ProductsFailure) {
          return CustomErrorWidget(errMessage: 'Error: ${state.errMessage}');
        } else if (state is ProductsDataState &&
            state.products != null &&
            state.products!.results != null &&
            state.products!.results!.isNotEmpty) {
          return CategoryProductsView(
            category: 0,
            products: state.products!,
            roleId: 1,
          );
        } else if (state is ProductsDataState &&
            (state.products == null ||
                state.products!.results == null ||
                state.products!.results!.isEmpty)) {
          return const CustomErrorWidget(errMessage: "No products available");
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    context.read<ProductsCubit>().getAllSellerProducts(),
                child: const Text("Retry"),
              ),
            ],
          ),
        );
        // return const CustomLoadingIndicator();
      },
    );
  }
}
