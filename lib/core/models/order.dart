import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_m/core/enums/payment_status.dart';

class Order {
  final String id;
  final String uid;
  final double amount;
  final String paymentStatus;
  final DateTime createdAt;
  final String? paymentId;
  final String? paymentMethod;
  final DateTime? updatedAt;

  Order({
    required this.id,
    required this.uid,
    required this.amount,
    required this.paymentStatus,
    required this.createdAt,
    this.paymentId,
    this.paymentMethod,
    this.updatedAt,
  });

  Order copyWith({
    String? id,
    String? uid,
    double? amount,
    String? paymentStatus,
    DateTime? createdAt,
    String? paymentId,
    String? paymentMethod,
    DateTime? updatedAt,
  }) {
    return Order(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      amount: amount ?? this.amount,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      createdAt: createdAt ?? this.createdAt,
      paymentId: paymentId ?? this.paymentId,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'amount': amount,
      'paymentStatus': paymentStatus,
      'createdAt': Timestamp.fromDate(createdAt),
      'paymentId': paymentId,
      'paymentMethod': paymentMethod,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  bool get fair =>
      paymentStatus == PaymentStatus.success &&
      createdAt
          .add(
            const Duration(days: 31),
          )
          .isBefore(
            DateTime.now(),
          );

  bool get unfair =>
      paymentStatus == PaymentStatus.success &&
      createdAt
          .add(
            const Duration(days: 31),
          )
          .isAfter(
            DateTime.now(),
          );

  factory Order.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return Order(
      id: doc.id,
      uid: map['uid'],
      amount: map['amount'].toDouble(),
      paymentStatus: map['paymentStatus'],
      createdAt: map['createdAt'].toDate(),
      paymentId: map['paymentId'],
      paymentMethod: map['paymentMethod'],
      updatedAt: map['updatedAt']?.toDate(),
    );
  }
}
