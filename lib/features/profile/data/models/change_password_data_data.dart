import 'package:equatable/equatable.dart';

class ChangePasswordData extends Equatable {
  final String? oldPassword;
  final String? newPassword;
  final String? confirmNewPassword;

  const ChangePasswordData({
    this.oldPassword,
    this.newPassword,
    this.confirmNewPassword,
  });

  factory ChangePasswordData.fromJson(Map<String, dynamic> json) {
    return ChangePasswordData(
      oldPassword: json['old_password'] as String?,
      newPassword: json['new_password'] as String?,
      confirmNewPassword: json['confirm_new_password'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'old_password': oldPassword,
    'new_password': newPassword,
    'confirm_new_password': confirmNewPassword,
  };

  @override
  List<Object?> get props {
    return [oldPassword, newPassword, confirmNewPassword];
  }
}
