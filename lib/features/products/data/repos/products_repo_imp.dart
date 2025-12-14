import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:drop_z_ecommerce_app/core/errors/failure.dart';
import 'package:drop_z_ecommerce_app/core/utils/api_service.dart';
import 'package:drop_z_ecommerce_app/core/utils/repo_request.dart';
import 'package:drop_z_ecommerce_app/features/products/data/model/add_product_request.dart';
import 'package:drop_z_ecommerce_app/features/products/data/model/category_model/category_model.dart';
import 'package:drop_z_ecommerce_app/features/products/data/model/product_item_data_model/product_item_data_model.dart';
import 'package:drop_z_ecommerce_app/features/products/data/model/product_item_data_model/result.dart';
import 'package:drop_z_ecommerce_app/features/products/data/repos/products_repo.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProductsRepoImp extends ProductsRepo {
  ProductsRepoImp(this.apiService);
  final ApiService apiService;

  List<CategoryModel>? _cachedCategories;
  ProductItemDataModel? _cachedProducts;

  @override
  Future<Either<Failure, ProductItemDataModel>> getAllProducts() async {
    final productsBox = Hive.box('productsBox');

    try {
      var result = await apiService.get(endPoint: "/products/");

      ProductItemDataModel productItemDataModel = ProductItemDataModel.fromJson(
        result,
      );
      await productsBox.put("products", productItemDataModel);

      _cachedProducts = productItemDataModel;
      return right(productItemDataModel);
    } catch (e) {
      if (productsBox.containsKey("products")) {
        final cached = productsBox.get("products") as ProductItemDataModel;
        return right(cached);
      }

      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CategoryModel>>> getAllCategories() async {
    final categoriesBox = Hive.box('categoriesBox');

    try {
      var result = await apiService.get(endPoint: "/categories/");

      final List<CategoryModel> categoryModel = (result as List)
          .map((item) => CategoryModel.fromJson(item))
          .toList();
      await categoriesBox.put("categories", categoryModel);

      _cachedCategories = categoryModel;
      return right(categoryModel);
    } catch (e) {
      if (categoriesBox.containsKey("categories")) {
        final cached = (categoriesBox.get("categories") as List)
            .cast<CategoryModel>();
        return right(cached);
      }

      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductItemDataModel>> getProductById(int id) async {
    return RepoRequest.call(
      request: () async {
        final result = await apiService.get(endPoint: "/products/$id");
        return ProductItemDataModel.fromJson(result);
      },
      parser: (data) => data,
    );
  }

  @override
  Future<Either<Failure, Result>> addProductItem(
    AddProductRequest addProductRequest,
  ) async {
    return RepoRequest.call(
      request: () async {
        final result = await apiService.post(
          endPoint: "/seller/products/",
          data: addProductRequest.toFormData(),
          isImage: true,
        );
        return Result.fromJson(result);
      },
      parser: (data) => data,
    );
  }

  @override
  Future<Either<Failure, Result>> updateProductItem(
    int id,
    AddProductRequest addProductRequest,
  ) async {
    return RepoRequest.call(
      request: () async {
        FormData formData = FormData.fromMap({
          'title': addProductRequest.title,
          'description': addProductRequest.description,
          'price': addProductRequest.price,
          'stock_quantity': addProductRequest.stockQuantity,
          'category': addProductRequest.category,
          'is_active': addProductRequest.isActive,
        });

        File? imageToUpload;
        if (addProductRequest.imageFile != null) {
          imageToUpload = addProductRequest.imageFile;
        } else if (addProductRequest.imageUrl != null &&
            addProductRequest.imageUrl!.isNotEmpty) {
          imageToUpload = await apiService.downloadImage(
            addProductRequest.imageUrl!,
          );
        }

        if (imageToUpload != null) {
          final fileName = imageToUpload.path.split('/').last;
          formData.files.add(
            MapEntry(
              'image',
              await MultipartFile.fromFile(
                imageToUpload.path,
                filename: fileName,
              ),
            ),
          );
        }

        final result = await apiService.put(
          endPoint: "/seller/products/$id/",
          data: formData,
          isImage: true,
        );

        if (imageToUpload != null && imageToUpload.path.contains('temp_')) {
          await imageToUpload.delete().catchError((_) {});
        }

        return Result.fromJson(result);
      },
      parser: (data) => data,
    );
  }

  @override
  Future<Either<Failure, String>> deleteProductItem(int id) async {
    return RepoRequest.call(
      request: () async {
        final result = await apiService.delete(
          endPoint: "/seller/products/$id/",
        );
        if (result.statusCode == 204) return "Product deleted successfully";
        return result.data?["message"] ?? "Deleted successfully";
      },
      parser: (data) => data,
    );
  }

  @override
  Future<Either<Failure, ProductItemDataModel>> getAllSellerProducts() async {
    return getAllProducts();
  }

  @override
  Future<void> clearCacheAndReload() async {
    _cachedCategories = null;
    _cachedProducts = null;
  }
}
