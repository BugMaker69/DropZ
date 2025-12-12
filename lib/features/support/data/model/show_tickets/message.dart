import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final int? id;
  final int? sender;
  final String? senderName;
  final String? message;
  final DateTime? createdAt;

  const Message({
    this.id,
    this.sender,
    this.senderName,
    this.message,
    this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json['id'] as int?,
    sender: json['sender'] as int?,
    senderName: json['sender_name'] as String?,
    message: json['message'] as String?,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'sender': sender,
    'sender_name': senderName,
    'message': message,
    'created_at': createdAt?.toIso8601String(),
  };

  @override
  List<Object?> get props => [id, sender, senderName, message, createdAt];
}
