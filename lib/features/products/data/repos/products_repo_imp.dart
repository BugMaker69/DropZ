import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:drop_z_ecommerce_app/core/errors/failure.dart';
import 'package:drop_z_ecommerce_app/core/utils/api_service.dart';
import 'package:drop_z_ecommerce_app/features/products/data/model/add_product_request.dart';
import 'package:drop_z_ecommerce_app/features/products/data/model/category_model/category_model.dart';
import 'package:drop_z_ecommerce_app/features/products/data/model/product_item_data_model/product_item_data_model.dart';
import 'package:drop_z_ecommerce_app/features/products/data/model/product_item_data_model/result.dart';
import 'package:drop_z_ecommerce_app/features/products/data/repos/products_repo.dart';

class ProductsRepoImp extends ProductsRepo {
  ProductsRepoImp(this.apiService);
  final ApiService apiService;
  List<CategoryModel>? _cachedCategories;
  ProductItemDataModel? _cachedProducts;

  @override
  Future<Either<Failure, ProductItemDataModel>> getAllProducts() async {
    if (_cachedProducts != null) {
      return Right(_cachedProducts!);
    }
    try {
      var result = await apiService.get(endPoint: "/products/");

      print("DAta Products + ${result}");

      ProductItemDataModel productItemDataModel = ProductItemDataModel.fromJson(
        result,
      );
      _cachedProducts = productItemDataModel;
      return right(productItemDataModel);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CategoryModel>>> getAllCategories() async {
    if (_cachedCategories != null) {
      return Right(_cachedCategories!);
    }
    try {
      var result = await apiService.get(endPoint: "/categories/");

      print("DAta Products + ${result}");

      // CategoryModel categoryModel = CategoryModel.fromJson(result);
      // final categoryModel = result.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>)).toList();
      final List<CategoryModel> categoryModel = (result as List)
          .map((item) => CategoryModel.fromJson(item))
          .toList();
      _cachedCategories = categoryModel;
      return right(categoryModel);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  Future<void> clearCacheAndReload() async {
    _cachedCategories = null;
    _cachedProducts = null;
  }

  @override
  Future<Either<Failure, Result>> AddProductItem(
    AddProductRequest addProductRequest,
  ) async {
    try {
      var result = await apiService.post(
        endPoint: "/seller/products/",
        data: addProductRequest.toFormData(),
        isImage: true,
      );
      print("DAta AddProducts + ${result}");

      Result data = Result.fromJson(result);
      return right(data);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Result>> updateProductItem(
    int id,
    AddProductRequest addProductRequest,
  ) async {
    try {
      FormData formData = FormData.fromMap({
        'title': addProductRequest.title,
        'description': addProductRequest.description,
        'price': addProductRequest.price,
        'stock_quantity': addProductRequest.stockQuantity,
        'category': addProductRequest.category,
        'is_active': addProductRequest.isActive,
      });

      File? imageToUpload;

      // 1. لو رفع صورة جديدة → استخدمها
      if (addProductRequest.imageFile != null) {
        imageToUpload = addProductRequest.imageFile;
      }
      // 2. لو ما رفعش صورة، بس عنده imageUrl قديم → حملها
      else if (addProductRequest.imageUrl != null &&
          addProductRequest.imageUrl!.isNotEmpty) {
        imageToUpload = await apiService.downloadImage(
          addProductRequest.imageUrl!,
        );
      }

      // 3. لو في صورة (جديدة أو محملة) → أضفها للـ request
      if (imageToUpload != null) {
        String fileName = imageToUpload.path.split('/').last;
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
      var result = await apiService.put(
        endPoint: "/seller/products/$id/",
        data: formData,
        // data: await addProductRequest.toFormData(),
        isImage: true,
      );

      if (imageToUpload != null && imageToUpload.path.contains('temp_')) {
        try {
          await imageToUpload.delete();
        } catch (e) {
          print("Failed to delete temp image: $e");
        }
      }
      print("DAta AddProducts + ${result}");

      Result data = Result.fromJson(result);
      return right(data);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> deleteProductItem(int id) async {
    try {
      var result = await apiService.delete(endPoint: "/seller/products/$id/");
      if (result.statusCode == 204) {
        return const Right("Product deleted successfully");
      }

      return right(result.data?["message"] ?? "Deleted successfully");
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
