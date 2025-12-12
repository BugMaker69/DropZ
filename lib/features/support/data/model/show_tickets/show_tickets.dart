import 'package:equatable/equatable.dart';

import 'message.dart';

class ShowTickets extends Equatable {
  final int? id;
  final int? customer;
  final String? customerEmail;
  final String? subject;
  final String? description;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Message>? messages;

  const ShowTickets({
    this.id,
    this.customer,
    this.customerEmail,
    this.subject,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.messages,
  });

  factory ShowTickets.fromJson(Map<String, dynamic> json) => ShowTickets(
    id: json['id'] as int?,
    customer: json['customer'] as int?,
    customerEmail: json['customer_email'] as String?,
    subject: json['subject'] as String?,
    description: json['description'] as String?,
    status: json['status'] as String?,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => Message.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'customer': customer,
    'customer_email': customerEmail,
    'subject': subject,
    'description': description,
    'status': status,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'messages': messages?.map((e) => e.toJson()).toList(),
  };

  ShowTickets copyWith({
    int? id,
    int? customer,
    String? customerEmail,
    String? subject,
    String? description,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Message>? messages,
  }) {
    return ShowTickets(
      id: id ?? this.id,
      customer: customer ?? this.customer,
      customerEmail: customerEmail ?? this.customerEmail,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      customer,
      customerEmail,
      subject,
      description,
      status,
      createdAt,
      updatedAt,
      messages,
    ];
  }
}
