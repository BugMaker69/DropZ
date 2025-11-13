import 'package:equatable/equatable.dart';

import 'result.dart';

class ProductItemDataModel extends Equatable {
  final int? totalItems;
  final int? totalPages;
  final int? currentPage;
  final List<Result>? results;

  const ProductItemDataModel({
    this.totalItems,
    this.totalPages,
    this.currentPage,
    this.results,
  });

  factory ProductItemDataModel.fromJson(Map<String, dynamic> json) {
    return ProductItemDataModel(
      totalItems: json['total_items'] as int?,
      totalPages: json['total_pages'] as int?,
      currentPage: json['current_page'] as int?,
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => Result.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'total_items': totalItems,
    'total_pages': totalPages,
    'current_page': currentPage,
    'results': results?.map((e) => e.toJson()).toList(),
  };

  @override
  List<Object?> get props {
    return [totalItems, totalPages, currentPage, results];
  }
}
