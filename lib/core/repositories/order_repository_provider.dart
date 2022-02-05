import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_m/core/enums/payment_status.dart';
import 'package:delivery_m/core/models/order.dart';
import 'package:delivery_m/utils/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

final orderRepositoryProvider = Provider((ref) => OrderRepository());

class OrderRepository {
  final _firestore = FirebaseFirestore.instance;

  Stream<List<Order>> ordersStream(String id) {
    return _firestore
        .collection(Constants.orders)
        .orderBy(Constants.createdAt, descending: true)
        .limit(1)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Order.fromFirestore(e),
              )
              .toList(),
        );
  }

  Future<String> createOrder({
    required String uid,
    required double amount,
  }) async {
    const String username = 'rzp_test_KmPzyFK6pErbkC';
    const String password = 'HDLsL5DxJOc4dxdk0lrQTww2';
    final String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    final order = Order(
      id: '',
      uid: uid,
      amount: amount,
      paymentStatus: PaymentStatus.processing,
      createdAt: DateTime.now(),
    );
    final response =
        await http.post(Uri.parse('https://api.razorpay.com/v1/orders'),
            headers: {
              'Content-Type': 'application/json',
              'authorization': basicAuth,
            },
            body: jsonEncode({
              "amount": (order.amount * 100).toInt(),
              "currency": "INR",
            }));
    if (response.statusCode == 200) {
      final id = jsonDecode(response.body)["id"];
      final doc = _firestore.collection(Constants.orders).doc(id);
      doc.set(
        order.toMap(),
      );
      return doc.id;
    } else {
      return Future.error(jsonDecode(response.body)["error"]["description"]);
    }
  }

  Future<void> update({
    required Map<String, dynamic> map,
    required String id,
  }) async {
    await _firestore.collection(Constants.orders).doc(id).update({
      ...map,
      Constants.updatedAt: Timestamp.now(),
    });
  }
}
