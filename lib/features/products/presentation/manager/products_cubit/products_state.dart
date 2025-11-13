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

  ProductsFailure(this.errMessage);
}

final class DeleteProductSuccess extends ProductsState {
  final String message;

  DeleteProductSuccess(this.message);
}

final class AddProductSuccess extends ProductsState {
  final ProductItemDataModel result;

  AddProductSuccess(this.result);
}

final class CategorySuccess extends ProductsState {
  final List<CategoryModel> categoryModel;

  CategorySuccess(this.categoryModel);
}

class ProductsDataState extends ProductsState {
  final List<CategoryModel>? categories;
  final ProductItemDataModel? products;
  final String? errorMessage;

  const ProductsDataState({this.categories, this.products, this.errorMessage});
}

/*
final class ProductsSuccess extends ProductsState {
  final ProductItemDataModel productItemDataModel;

  ProductsSuccess(this.productItemDataModel);
}

final class CategoryLoading extends ProductsState {}

final class CategorySuccess extends ProductsState {
  final List<CategoryModel> categoryModel;

  CategorySuccess(this.categoryModel);
}

final class CategoryFailure extends ProductsState {
  final String errMessage;

  CategoryFailure(this.errMessage);
}
*/
