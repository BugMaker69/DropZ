import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final int? id;
  final String? name;
  final String? slug;
  final dynamic parentCategory;
  final List<dynamic>? subcategories;

  const CategoryModel({
    this.id,
    this.name,
    this.slug,
    this.parentCategory,
    this.subcategories,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json['id'] as int?,
    name: json['name'] as String?,
    slug: json['slug'] as String?,
    parentCategory: json['parent_category'] as dynamic,
    subcategories: json['subcategories'] as List<dynamic>?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'slug': slug,
    'parent_category': parentCategory,
    'subcategories': subcategories,
  };

  @override
  List<Object?> get props {
    return [id, name, slug, parentCategory, subcategories];
  }
}
