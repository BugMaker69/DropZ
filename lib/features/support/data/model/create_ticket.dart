import 'package:equatable/equatable.dart';

class CreateTicket extends Equatable {
  final String? subject;
  final String? description;

  const CreateTicket({this.subject, this.description});

  factory CreateTicket.fromJson(Map<String, dynamic> json) => CreateTicket(
    subject: json['subject'] as String?,
    description: json['description'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'subject': subject,
    'description': description,
  };

  @override
  List<Object?> get props => [subject, description];
}
