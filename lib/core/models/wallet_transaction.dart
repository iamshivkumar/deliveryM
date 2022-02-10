import 'package:cloud_firestore/cloud_firestore.dart';

class WalletTransaction {
  final String id;
  final String cId;
  final String sId;
  final String dId;
  final String pId;
  final String date;
  final String name;
  final int quantity;
  final double amount;
  final double balance;
  final DateTime createdAt;

  WalletTransaction({
    required this.id,
    required this.cId,
    required this.sId,
    required this.dId,
    required this.date,
    required this.quantity,
    required this.amount,
    required this.createdAt,
    required this.pId,
    required this.name,
    required this.balance,
  });

  WalletTransaction copyWith({
    String? id,
    String? cId,
    String? sId,
    String? dId,
    String? date,
    int? quantity,
    double? amount,
    DateTime? createdAt,
    String? pId,
    String? name,
    double? balance,
  }) {
    return WalletTransaction(
      id: id ?? this.id,
      cId: cId ?? this.cId,
      sId: sId ?? this.sId,
      dId: dId ?? this.dId,
      pId: pId??this.pId,
      date: date ?? this.date,
      quantity: quantity ?? this.quantity,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      name: name??this.name,
      balance: balance??this.balance
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cId': cId,
      'sId': sId,
      'dId': dId,
      'pId':pId,
      'date': date,
      'quantity': quantity,
      'amount': amount,
      'createdAt': Timestamp.fromDate(createdAt),
      'name':name,
      'balance': balance,
    };
  }

  factory WalletTransaction.fromMap(DocumentSnapshot doc) {
    final Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return WalletTransaction(
      id: doc.id,
      cId: map['cId'],
      sId: map['sId'],
      dId: map['dId'],
      pId: map['pId'],
      date: map['date'],
      quantity: map['quantity'].toInt(),
      amount: map['amount'].toDouble(),
      createdAt: map['createdAt'].toDate(),
      name: map['name'],
      balance: map['balance'],
    );
  }
}
