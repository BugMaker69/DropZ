import 'package:drop_z_ecommerce_app/features/products/data/model/product_item_data_model/result.dart';
import 'package:hive_flutter/adapters.dart';

class ResultAdapter extends TypeAdapter<Result> {
  @override
  final typeId = 3;

  @override
  Result read(BinaryReader reader) {
    return Result(
      id: reader.read(),
      seller: reader.read(),
      isInWishlist: reader.read(),
      averageRating: reader.read(),
      reviewCount: reader.read(),
      title: reader.read(),
      slug: reader.read(),
      description: reader.read(),
      image: reader.read(),
      price: reader.read(),
      stockQuantity: reader.read(),
      isActive: reader.read(),
      createdAt: reader.read(),
      updatedAt: reader.read(),
      category: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Result obj) {
    writer.write(obj.id);
    writer.write(obj.seller);
    writer.write(obj.isInWishlist);
    writer.write(obj.averageRating);
    writer.write(obj.reviewCount);
    writer.write(obj.title);
    writer.write(obj.slug);
    writer.write(obj.description);
    writer.write(obj.image);
    writer.write(obj.price);
    writer.write(obj.stockQuantity);
    writer.write(obj.isActive);
    writer.write(obj.createdAt);
    writer.write(obj.updatedAt);
    writer.write(obj.category);
  }
}
