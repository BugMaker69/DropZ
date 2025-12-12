import 'package:drop_z_ecommerce_app/features/products/data/model/product_item_data_model/product_item_data_model.dart';
import 'package:drop_z_ecommerce_app/features/products/data/model/product_item_data_model/result.dart';
import 'package:hive_flutter/adapters.dart';

class ProductItemDataModelAdapter extends TypeAdapter<ProductItemDataModel> {
  @override
  final typeId = 2;

  @override
  ProductItemDataModel read(BinaryReader reader) {
    return ProductItemDataModel(
      totalItems: reader.read(),
      totalPages: reader.read(),
      currentPage: reader.read(),
      results: (reader.read() as List?)?.cast<Result>(),
      // results: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, ProductItemDataModel obj) {
    writer.write(obj.totalItems);
    writer.write(obj.totalPages);
    writer.write(obj.currentPage);
    writer.write(obj.results);
  }
}
