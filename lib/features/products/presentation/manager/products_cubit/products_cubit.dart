import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:drop_z_ecommerce_app/core/errors/failure.dart';
import 'package:drop_z_ecommerce_app/features/products/data/model/add_product_request.dart';
import 'package:drop_z_ecommerce_app/features/products/data/model/category_model/category_model.dart';
import 'package:drop_z_ecommerce_app/features/products/data/model/product_item_data_model/product_item_data_model.dart';
import 'package:drop_z_ecommerce_app/features/products/data/repos/products_repo.dart';
import 'package:equatable/equatable.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(this.productsRepo) : super(ProductsInitial());

  final ProductsRepo productsRepo;
  List<CategoryModel>? categories;
  ProductItemDataModel? _products;

  Future<void> refreshAllData() async {
    await productsRepo.clearCacheAndReload(); // مسح الـ Cache
    await _loadData(); // تحميل البيانات من جديد
  }

  Future<void> _loadData() async {
    emit(ProductsLoading());

    // Run both in parallel
    final categoriesResult = productsRepo.getAllCategories();
    final productsResult = productsRepo.getAllProducts();

    final results = await Future.wait([categoriesResult, productsResult]);

    final categoryEither = results[0] as Either<Failure, List<CategoryModel>>;
    final productEither = results[1] as Either<Failure, ProductItemDataModel>;

    // Check for any failure
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
    // Both success
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
    var result = await productsRepo.getAllCategories();
    print("Categories Result: $result"); // للتحقق
    result.fold(
      (failure) {
        print("Category Failure: ${failure.errMessage}");
        emit(ProductsFailure(failure.errMessage));
      },
      (categoryModel) {
        print("Category Success: $categoryModel");
        emit(CategorySuccess(categoryModel));
      },
    );
  }

  Future<void> addProductItem(AddProductRequest addProductItem) async {
    emit(ProductsLoading());

    var result = await productsRepo.AddProductItem(addProductItem);

    result.fold((failure) => emit(ProductsFailure(failure.errMessage)), (
      data,
    ) async {
      _products!.results!.insert(0, data);
      emit(ProductsDataState(products: _products, categories: categories));
    });
  }

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
        emit(ProductsDataState(categories: categories, products: _products));
        // emit(ProductsSuccess(productSuccessResponse));
      },
    );
  }

  Future<void> updateProductItem(
    int id,
    AddProductRequest addProductItem,
  ) async {
    emit(ProductsLoading());

    var result = await productsRepo.updateProductItem(id, addProductItem);

    result.fold((failure) => emit(ProductsFailure(failure.errMessage)), (data) {
      _products!.results!.removeWhere((item) => item.id == data.id);
      _products!.results!.insert(0, data);
      emit(ProductsDataState(products: _products, categories: categories));
    });
  }

  Future<void> deleteProductItem(int id) async {
    emit(ProductsLoading());

    var result = await productsRepo.deleteProductItem(id);
    result.fold(
      (failure) => emit(ProductsFailure(failure.errMessage)),
      (message) => emit(DeleteProductSuccess(message)),
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
