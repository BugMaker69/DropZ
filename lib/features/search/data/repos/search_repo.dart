import 'package:dartz/dartz.dart';
import 'package:drop_z_ecommerce_app/core/errors/failure.dart';
import 'package:drop_z_ecommerce_app/features/products/data/model/product_item_data_model/product_item_data_model.dart';

abstract class SearchRepo {
  Future<Either<Failure, ProductItemDataModel>> searchProducts(String query);
}
