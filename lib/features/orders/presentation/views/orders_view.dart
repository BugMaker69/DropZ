import 'package:drop_z_ecommerce_app/core/utils/service_locator.dart';
import 'package:drop_z_ecommerce_app/features/orders/data/repos/orders_repo_imp.dart';
import 'package:drop_z_ecommerce_app/features/orders/presentation/manager/orders_cubit/orders_cubit.dart';
import 'package:drop_z_ecommerce_app/features/orders/presentation/views/widgets/orders_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          OrdersCubit(getIt.get<OrdersRepoImpl>())..getOrders(),
      child: OrdersViewBody(),
    );
  }
}
