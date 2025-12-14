import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:drop_z_ecommerce_app/core/errors/failure.dart';
import 'package:drop_z_ecommerce_app/core/utils/cubit_handler.dart';
import 'package:drop_z_ecommerce_app/features/products/data/model/add_product_request.dart';
import 'package:drop_z_ecommerce_app/features/products/data/model/category_model/category_model.dart';
import 'package:drop_z_ecommerce_app/features/products/data/model/product_item_data_model/product_item_data_model.dart';
import 'package:drop_z_ecommerce_app/features/products/data/model/product_item_data_model/result.dart';
import 'package:drop_z_ecommerce_app/features/products/data/repos/products_repo.dart';
import 'package:equatable/equatable.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(this.productsRepo) : super(ProductsInitial());

  final ProductsRepo productsRepo;
  List<CategoryModel>? categories;
  ProductItemDataModel? _products;

  Future<void> refreshAllData() async {
    await productsRepo.clearCacheAndReload();
    await _loadData();
  }

  Future<void> _loadData() async {
    emit(ProductsLoading());

    final categoriesResult = productsRepo.getAllCategories();
    final productsResult = productsRepo.getAllProducts();

    final results = await Future.wait([categoriesResult, productsResult]);

    final categoryEither = results[0] as Either<Failure, List<CategoryModel>>;
    final productEither = results[1] as Either<Failure, ProductItemDataModel>;

    if (categoryEither.isLeft()) {
      final failure = categoryEither.fold((l) => l, (r) => null);
      emit(ProductsFailure(failure!.errMessage));
      return;
    }
    if (productEither.isLeft()) {
      final failure = productEither.fold((l) => l, (r) => null);
      emit(ProductsFailure(failure!.errMessage));
      return;
    }

    categories = categoryEither.fold((l) => null, (r) => r)!;
    _products = productEither.fold((l) => null, (r) => r)!;

    emit(ProductsDataState(categories: categories, products: _products));
  }

  Future<void> loadAllData() async {
    if (categories != null && _products != null) {
      emit(ProductsDataState(categories: categories, products: _products));
      return;
    }
    await _loadData();
  }

  Future<void> getAllCategories() async {
    emit(ProductsLoading());

    await CubitHandler.run<List<CategoryModel>>(
      cubit: this,
      call: () => productsRepo.getAllCategories(),
      onSuccess: (cats) {
        categories = cats;
        emit(CategorySuccess(cats));
      },
      onError: (msg) => emit(ProductsFailure(msg)),
      loadingState: () {},
      failureState: (msg) => emit(ProductsFailure(msg)),
    );
  }

  Future<void> addProductItem(AddProductRequest addProductItem) async {
    emit(ProductsLoading());

    await CubitHandler.run<Result>(
      cubit: this,
      call: () => productsRepo.addProductItem(addProductItem),
      onSuccess: (data) {
        _products!.results!.insert(0, data);
        emit(ProductsDataState(products: _products, categories: categories));
      },
      onError: (msg) => emit(ProductsFailure(msg)),
      loadingState: () {},
      failureState: (msg) => emit(ProductsFailure(msg)),
    );
  }

  Future<void> getAllProducts() async {
    emit(ProductsLoading());

    await CubitHandler.run<ProductItemDataModel>(
      cubit: this,
      call: () => productsRepo.getAllProducts(),
      onSuccess: (prods) {
        _products = prods;
        emit(ProductsDataState(categories: categories, products: _products));
      },
      onError: (msg) => emit(ProductsFailure(msg)),
      loadingState: () {},
      failureState: (msg) => emit(ProductsFailure(msg)),
    );
  }

  Future<void> getProductDetails(int id) async {
    emit(ProductsLoading());

    await CubitHandler.run<ProductItemDataModel>(
      cubit: this,
      call: () => productsRepo.getProductById(id),
      onSuccess: (product) => emit(AddProductSuccess(product)),
      onError: (msg) => emit(ProductsFailure(msg)),
      loadingState: () {},
      failureState: (msg) => emit(ProductsFailure(msg)),
    );
  }

  Future<void> getAllSellerProducts() async {
    emit(ProductsLoading());

    await CubitHandler.run<ProductItemDataModel>(
      cubit: this,
      call: () => productsRepo.getAllSellerProducts(),
      onSuccess: (prods) {
        _products = prods;
        emit(ProductsDataState(categories: categories, products: _products));
      },
      onError: (msg) => emit(ProductsFailure(msg)),
      loadingState: () {},
      failureState: (msg) => emit(ProductsFailure(msg)),
    );
  }

  Future<void> updateProductItem(
    int id,
    AddProductRequest addProductItem,
  ) async {
    emit(ProductsLoading());

    await CubitHandler.run<Result>(
      cubit: this,
      call: () => productsRepo.updateProductItem(id, addProductItem),
      onSuccess: (data) {
        _products!.results!.removeWhere((item) => item.id == data.id);
        _products!.results!.insert(0, data);
        emit(ProductsDataState(products: _products, categories: categories));
      },
      onError: (msg) => emit(ProductsFailure(msg)),
      loadingState: () {},
      failureState: (msg) => emit(ProductsFailure(msg)),
    );
  }

  Future<void> deleteProductItem(int id) async {
    emit(ProductsLoading());

    await CubitHandler.run<String>(
      cubit: this,
      call: () => productsRepo.deleteProductItem(id),
      onSuccess: (msg) => emit(DeleteProductSuccess(msg)),
      onError: (msg) => emit(ProductsFailure(msg)),
      loadingState: () {},
      failureState: (msg) => emit(ProductsFailure(msg)),
    );
  }
}

/*
class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(this.productsRepo) : super(ProductsInitial());

  ProductsRepo productsRepo;
  List<CategoryModel>? categories;
  ProductItemDataModel? _products;

  Future<void> getAllProducts() async {
    emit(ProductsLoading());
    var result = await productsRepo.getAllProducts();

    result.fold(
      (failure) {
        emit(ProductsFailure(failure.errMessage));
      },
      (productSuccessResponse) {
        _products = productSuccessResponse;
        print(
          "Products Success: ${productSuccessResponse.results?.length} products",
        );
        emit(ProductsDataState(categories: _categories, products: _products));
        // emit(ProductsSuccess(productSuccessResponse));
      },
    );
  }

  Future<void> getAllCategories() async {
    emit(ProductsLoading());
    var result = await productsRepo.getAllCategories();
    print("Categories Result: $result"); // للتحقق
    result.fold(
      (failure) {
        print("Category Failure: ${failure.errMessage}");
        emit(ProductsFailure(failure.errMessage));
      },
      (categoryModel) {
        _categories = categoryModel;
        print("Category Success: $categoryModel");
        emit(ProductsDataState(categories: _categories, products: _products));
        // emit(CategorySuccess(categoryModel));
      },
    );
  }
}
*/
