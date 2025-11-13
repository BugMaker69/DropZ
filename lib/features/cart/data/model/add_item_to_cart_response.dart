import 'package:equatable/equatable.dart';

class AddItemToCartResponse extends Equatable {
  final String? detail;
  final int? productId;
  final int? newQuantity;

  const AddItemToCartResponse({this.detail, this.productId, this.newQuantity});

  factory AddItemToCartResponse.fromJson(Map<String, dynamic> json) {
    return AddItemToCartResponse(
      detail: json['detail'] as String?,
      productId: json['product_id'] as int?,
      newQuantity: json['new_quantity'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'detail': detail,
    'product_id': productId,
    'new_quantity': newQuantity,
  };

  @override
  List<Object?> get props => [detail, productId, newQuantity];
}
