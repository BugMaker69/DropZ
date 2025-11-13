import 'package:equatable/equatable.dart';

class AddRemoveProductToWishListResponse extends Equatable {
  final String? detail;

  const AddRemoveProductToWishListResponse({this.detail});

  factory AddRemoveProductToWishListResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return AddRemoveProductToWishListResponse(
      detail: json['detail'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {'detail': detail};

  @override
  List<Object?> get props => [detail];
}
