import 'package:bloc/bloc.dart';
import 'package:drop_z_ecommerce_app/core/utils/cubit_handler.dart';
import 'package:drop_z_ecommerce_app/features/products/data/model/product_item_data_model/product_item_data_model.dart';
import 'package:drop_z_ecommerce_app/features/search/data/repos/search_repo.dart';
import 'package:equatable/equatable.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepo searchRepo;

  SearchCubit(this.searchRepo) : super(SearchInitial());

  Future<void> search(String query) async {
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      emit(SearchInitial());
      return;
    }

    await CubitHandler.run<ProductItemDataModel>(
      cubit: this,
      loadingState: () => emit(SearchLoading()),
      call: () => searchRepo.searchProducts(trimmedQuery),
      onSuccess: (data) => emit(SearchSuccess(data)),
      failureState: (msg) => emit(SearchFailure(msg)),
    );
  }
}
