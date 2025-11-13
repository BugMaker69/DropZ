import 'package:equatable/equatable.dart';

import 'item.dart';

class WishListDataResponse extends Equatable {
  final int? id;
  final List<Item>? items;
  final int? count;

  const WishListDataResponse({this.id, this.items, this.count});

  factory WishListDataResponse.fromJson(Map<String, dynamic> json) {
    return WishListDataResponse(
      id: json['id'] as int?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: json['count'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'items': items?.map((e) => e.toJson()).toList(),
    'count': count,
  };

  @override
  List<Object?> get props => [id, items, count];
}
