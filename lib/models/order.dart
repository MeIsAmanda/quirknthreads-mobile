import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import 'order_status.dart';

class Order {
  final String id;
  final String userId;
  final OrderStatus status;
  final double total;
  final List<Map<String,dynamic>> items;
  final DateTime? createdAt;

  Order({
    required this.id,
    required this.userId,
    required this.status,
    required this.total,
    required this.items,
    this.createdAt,
});

  Order copyWith({
    String? id,
    String? userId,
    OrderStatus? status,
    double? total,
    List<Map<String, dynamic>>? items,
    DateTime? createdAt,
}) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      total: total ?? this.total,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Order.fromJson(Map<String, dynamic> json, {String? id}) {
    return Order(
      id: id ?? json['id'] ?? const Uuid().v4(),
      userId: json['userId'],
      status: OrderStatus.values[json['status']],
      total: json['total'].toDouble(),
      items: json['items']
        .map((item) => item)
        .toList()
        .cast<Map<String, dynamic>>() as List<Map<String, dynamic>>,
      createdAt: json['createdAt'].toDate(),
    );

  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'userId': userId,
      'status': status.index,
      'total': total,
      'items': items,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
  
}