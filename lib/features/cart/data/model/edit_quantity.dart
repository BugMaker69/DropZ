import 'package:equatable/equatable.dart';

class EditQuantity extends Equatable {
  final int? quantity;

  const EditQuantity({this.quantity});

  factory EditQuantity.fromJson(Map<String, dynamic> json) =>
      EditQuantity(quantity: json['quantity'] as int?);

  Map<String, dynamic> toJson() => {'quantity': quantity};

  @override
  List<Object?> get props => [quantity];
}
