import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:db_client/db_client.dart';

import '../models/order.dart';
import '../models/order_status.dart';

class OrderRepository {
  final DbClient dbClient;

  const OrderRepository({required this.dbClient});

  Future<String> createOrder({
    required String userId,
    required List<Map<String, dynamic>> items,
    required double total,
  }) async {
      try{
        final orderId = await dbClient.add(
          collection: 'orders',
          data: {
            'userId': userId,
            'items': items,
            'totalAmount': total,
            'orderStatus': OrderStatus.processing.label,
            'date': FieldValue.serverTimestamp(),
            'deliveryStatus': '',
            'deliveryPersonnelId': '',
            'address': 'Blk 123 Jurong West St 11 Singapore 555123',
          },
        );
        return orderId;
      } catch (err) {
        throw Exception('Error creating order: $err');
      }
  }

  Future<Order> fetchOrder(String orderId) async {
    try{
      final orderData = await dbClient.fetchOneById(
        collection: 'orders',
        documentId: orderId,
      );

      if (orderData ==null) {
        throw Exception('Order not found');
      }

      return Order.fromJson(orderData.data, id: orderData.id);
    } catch (err) {
      throw Exception('Error fetching order: $err');
    }
  }

  Future<List<Order>> fetchOrders(String userId) async {
    try{
      final ordersData = await dbClient.fetchAllBy(
        collection: 'orders',
        field: 'userId',
        value: userId,
      );
      return ordersData
          .map((orderData) => Order.fromJson(orderData.data, id: orderData.id))
          .toList();
    } catch (err) {
      throw Exception('Error fetching orders: $err');
    }
  }

}