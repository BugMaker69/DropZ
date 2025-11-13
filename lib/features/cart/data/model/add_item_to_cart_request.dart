import 'package:equatable/equatable.dart';

class AddItemToCartRequest extends Equatable {
  final int? productId;
  final int? quantity;

  const AddItemToCartRequest({this.productId, this.quantity});

  factory AddItemToCartRequest.fromJson(Map<String, dynamic> json) {
    return AddItemToCartRequest(
      productId: json['product_id'] as int?,
      quantity: json['quantity'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'product_id': productId,
    'quantity': quantity,
  };

  @override
  List<Object?> get props => [productId, quantity];
}
