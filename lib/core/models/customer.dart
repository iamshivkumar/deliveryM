
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_m/core/models/address.dart';

class Customer {
  final String id;
  final String eId;
  final String name;
  final String mobile;
  final Address address;
  final List<String> documents;
  final double balance;

  Customer({
    required this.id,
    required this.eId,
    required this.name,
    required this.mobile,
    required this.address,
    required this.documents,
    required this.balance,
  });

  Customer copyWith({
    String? id,
    String? eId,
    String? name,
    String? mobile,
    Address? address,
    double? balance,
    List<String>? documents,
  }) {
    return Customer(
      id: id ?? this.id,
      eId: eId ?? this.eId,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      address: address ?? this.address,
      balance: balance??this.balance,
      documents: documents??this.documents,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'eId': eId,
      'name': name,
      'mobile': mobile,
      'address': address.toMap(),
      'balance': balance,
      'documents': documents,
    };
  }

  factory Customer.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return Customer(
      id: doc.id,
      eId: map['eId'],
      name: map['name'],
      mobile: map['mobile'],
      address: Address.fromMap(map['address']),
      balance: map['balance'],
      documents: List<String>.from(map['documents']),
    );
  }

    factory Customer.empty() {
    return Customer(
      id: '',
      eId: '',
      name: '',
      mobile: '',
      address: Address.empty(),
      balance: 0,
      documents: []
    );
  }
}
