import 'package:dartz/dartz.dart';
import 'package:drop_z_ecommerce_app/core/errors/failure.dart';
import 'package:drop_z_ecommerce_app/features/products/data/model/add_product_request.dart';
import 'package:drop_z_ecommerce_app/features/products/data/model/category_model/category_model.dart';
import 'package:drop_z_ecommerce_app/features/products/data/model/product_item_data_model/product_item_data_model.dart';
import 'package:drop_z_ecommerce_app/features/products/data/model/product_item_data_model/result.dart';

abstract class ProductsRepo {
  Future<Either<Failure, ProductItemDataModel>> getAllProducts();
  Future<Either<Failure, ProductItemDataModel>> getProductById(int id);
  Future<Either<Failure, ProductItemDataModel>> getAllSellerProducts();
  Future<Either<Failure, List<CategoryModel>>> getAllCategories();
  Future<Either<Failure, Result>> AddProductItem(
    AddProductRequest addProductRequest,
  );
  Future<Either<Failure, Result>> updateProductItem(
    int id,
    AddProductRequest addProductRequest,
  );
  Future<Either<Failure, String>> deleteProductItem(int id);
  Future<void> clearCacheAndReload();
}
