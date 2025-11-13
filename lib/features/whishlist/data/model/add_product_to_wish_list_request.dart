import 'package:equatable/equatable.dart';

class AddProductToWishListRequest extends Equatable {
  final int? productId;

  const AddProductToWishListRequest({this.productId});

  factory AddProductToWishListRequest.fromJson(Map<String, dynamic> json) {
    return AddProductToWishListRequest(productId: json['product_id'] as int?);
  }

  Map<String, dynamic> toJson() => {'product_id': productId};

  @override
  List<Object?> get props => [productId];
}
