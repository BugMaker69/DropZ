import 'package:drop_z_ecommerce_app/features/orders/presentation/manager/orders_cubit/orders_cubit.dart';
import 'package:drop_z_ecommerce_app/features/orders/presentation/views/widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersViewBody extends StatelessWidget {
  const OrdersViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          if (state is OrdersLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is OrdersFailure) {
            return Center(child: Text(state.message));
          }

          if (state is OrdersSuccess) {
            if (state.orders.isEmpty) {
              return const Center(child: Text('No orders found'));
            }

            return ListView.builder(
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                return OrderCard(order: state.orders[index]);
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
