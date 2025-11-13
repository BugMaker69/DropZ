import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int? id;
  final String? name;
  final String? email;
  final dynamic profileImage;

  const User({this.id, this.name, this.email, this.profileImage});

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as int?,
    name: json['name'] as String?,
    email: json['email'] as String?,
    profileImage: json['profile_image'] as dynamic,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'profile_image': profileImage,
  };

  @override
  List<Object?> get props => [id, name, email, profileImage];
}
