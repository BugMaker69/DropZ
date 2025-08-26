import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? firstName;
  final String? lastName;

  const User({this.firstName, this.lastName});

  factory User.fromJson(Map<String, dynamic> json) => User(
    firstName: json['first_name'] as String?,
    lastName: json['last_name'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'first_name': firstName,
    'last_name': lastName,
  };

  @override
  List<Object?> get props => [firstName, lastName];
}
