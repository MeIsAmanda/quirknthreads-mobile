import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import 'order_status.dart';

class Order {
  final String id;
  final String userId;
  final String orderStatus;
  final double totalAmount;
  final List<Map<String,dynamic>> items;
  final Timestamp date;

  Order({
    required this.id,
    required this.userId,
    required this.orderStatus,
    required this.totalAmount,
    required this.items,
    required this.date,
});

  Order copyWith({
    String? id,
    String? userId,
    String? orderStatus,
    double? totalAmount,
    List<Map<String, dynamic>>? items,
    Timestamp? date,
}) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      orderStatus: orderStatus ?? this.orderStatus,
      totalAmount: totalAmount ?? this.totalAmount,
      items: items ?? this.items,
      date: date ?? this.date,
    );
  }

  factory Order.fromJson(Map<String, dynamic> json, {String? id}) {
    print("printing from json");
    print(json);
    return Order(
      id: id ?? json['id'] ?? const Uuid().v4(),
      userId: json['userId'],
      orderStatus: json['orderStatus'],
      totalAmount: json['totalAmount'].toDouble(),
      items: json['items']
        .map((item) => item)
        .toList()
        .cast<Map<String, dynamic>>() as List<Map<String, dynamic>>,
      date: json['date'],
    );

  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'userId': userId,
      'orderStatus': orderStatus,
      'totalAmount': totalAmount,
      'items': items,
      'date': date ?? FieldValue.serverTimestamp(),
    };
  }
  
}