import 'package:bloc/bloc.dart';
import 'package:drop_z_ecommerce_app/core/utils/cubit_handler.dart';
import 'package:drop_z_ecommerce_app/features/orders/data/model/order_model.dart';
import 'package:drop_z_ecommerce_app/features/orders/data/repos/orders_repo.dart';
import 'package:equatable/equatable.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit(this.ordersRepo) : super(OrdersInitial());

  final OrdersRepo ordersRepo;

  Future<void> getOrders() async {
    await CubitHandler.run<List<OrderModel>>(
      cubit: this,
      loadingState: () => emit(OrdersLoading()),
      failureState: (msg) => emit(OrdersFailure(msg)),
      call: () => ordersRepo.getOrders(),
      onSuccess: (orders) => emit(OrdersSuccess(orders)),
    );
  }
}
