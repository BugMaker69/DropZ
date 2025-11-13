import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

class AddProductRequest extends Equatable {
  final String? title;
  final String? description;
  final double? price;
  final int? stockQuantity;
  final int? category;
  final bool? isActive;
  final File? imageFile;
  final String? imageUrl;

  const AddProductRequest({
    this.title,
    this.description,
    this.price,
    this.stockQuantity,
    this.category,
    this.isActive,
    this.imageFile,
    this.imageUrl,
  });

  factory AddProductRequest.fromJson(Map<String, dynamic> json) {
    return AddProductRequest(
      title: json['title'] as String?,
      description: json['description'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      stockQuantity: json['stock_quantity'] as int?,
      category: json['category'] as int?,
      isActive: json['is_active'] as bool?,
      imageFile: json['image'] != null ? File(json['image']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'price': price,
    'stock_quantity': stockQuantity,
    'category': category,
    'is_active': isActive,
    'image': imageFile?.path.split('/').last,
  };

  FormData toFormData() {
    return FormData.fromMap({
      'title': title,
      'description': description,
      'price': price,
      'stock_quantity': stockQuantity,
      'category': category,
      'is_active': isActive,
      if (imageFile != null)
        'image': MultipartFile.fromFileSync(
          imageFile!.path,
          filename: imageFile!.path.split('/').last,
        ),
    });
  }

  /*
  Future<FormData> toFormData() async {
    final formMap = {
      'name': title,
      'description': description,
      'price': price,
      'stock': stockQuantity,
      'category': category,
      'is_active': isActive,
    };

    if (imageFile != null) {
      formMap['image'] = await MultipartFile.fromFile(
        imageFile!.path,
        filename: imageFile!.path.split('/').last,
      );
    }

    return FormData.fromMap(formMap);
  }
*/
  @override
  List<Object?> get props {
    return [
      title,
      description,
      price,
      stockQuantity,
      category,
      isActive,
      imageFile,
    ];
  }
}
