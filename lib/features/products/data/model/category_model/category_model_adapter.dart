import 'package:drop_z_ecommerce_app/features/products/data/model/category_model/category_model.dart';
import 'package:hive_flutter/adapters.dart';

class CategoryModelAdapter extends TypeAdapter<CategoryModel> {
  @override
  final typeId = 1;

  @override
  CategoryModel read(BinaryReader reader) {
    return CategoryModel(
      id: reader.readInt(),
      name: reader.readString(),
      slug: reader.readString(),
      parentCategory: reader.read(),
      subcategories: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, CategoryModel obj) {
    writer.writeInt(obj.id!);
    writer.writeString(obj.name!);
    writer.writeString(obj.slug!);
    writer.write(obj.parentCategory);
    writer.write(obj.subcategories);
  }
}
