import 'package:equatable/equatable.dart';

class DeleteItemResponse extends Equatable {
  final String? detail;

  const DeleteItemResponse({this.detail});

  factory DeleteItemResponse.fromJson(Map<String, dynamic> json) {
    return DeleteItemResponse(detail: json['detail'] as String?);
  }

  Map<String, dynamic> toJson() => {'detail': detail};

  @override
  List<Object?> get props => [detail];
}
