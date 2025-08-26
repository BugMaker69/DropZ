import 'package:equatable/equatable.dart';

import 'message.dart';

class GetUserDataFailure extends Equatable {
  final String? detail;
  final String? code;
  final List<Message>? messages;

  const GetUserDataFailure({this.detail, this.code, this.messages});

  factory GetUserDataFailure.fromJson(Map<String, dynamic> json) {
    return GetUserDataFailure(
      detail: json['detail'] as String?,
      code: json['code'] as String?,
      messages: (json['messages'] as List<dynamic>?)
          ?.map((e) => Message.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'detail': detail,
    'code': code,
    'messages': messages?.map((e) => e.toJson()).toList(),
  };

  @override
  List<Object?> get props => [detail, code, messages];
}
