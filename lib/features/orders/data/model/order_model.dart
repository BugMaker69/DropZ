import 'package:drop_z_ecommerce_app/features/orders/data/model/order_item_model.dart';

class OrderModel {
  final int id;
  final String status;
  final int? shippingAddress;
  final int? paymobOrderId;
  final List<OrderItemModel> items;
  final double totalCents;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.status,
    required this.shippingAddress,
    required this.paymobOrderId,
    required this.items,
    required this.totalCents,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      status: json['status'] ?? '',
      shippingAddress: json['shipping_address'],
      paymobOrderId: json['paymob_order_id'],
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => OrderItemModel.fromJson(e))
          .toList(),
      totalCents: (json['total_cents'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  /// السعر بالجنيه (للعرض في UI)
  double get totalPrice => totalCents / 100;

  /// عدد المنتجات في الأوردر
  int get itemsCount => items.fold(0, (sum, item) => sum + item.quantity);
}
