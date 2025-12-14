part of 'products_cubit.dart';

sealed class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object> get props => [];
}

final class ProductsInitial extends ProductsState {}

final class ProductsLoading extends ProductsState {}

final class ProductsFailure extends ProductsState {
  final String errMessage;

  const ProductsFailure(this.errMessage);
}

final class DeleteProductSuccess extends ProductsState {
  final String message;

  const DeleteProductSuccess(this.message);
}

final class AddProductSuccess extends ProductsState {
  final ProductItemDataModel result;

  const AddProductSuccess(this.result);
}

final class CategorySuccess extends ProductsState {
  final List<CategoryModel> categoryModel;

  const CategorySuccess(this.categoryModel);
}

class ProductsDataState extends ProductsState {
  final List<CategoryModel>? categories;
  final ProductItemDataModel? products;
  final String? errorMessage;

  const ProductsDataState({this.categories, this.products, this.errorMessage});
}
