
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String eId;
  final String image;
  final String name;
  final double price;
  final bool returnKit;

  Product({
    required this.id,
    required this.eId,
    required this.image,
    required this.name,
    required this.price,
    required this.returnKit,
  });

  Product copyWith({
    String? id,
    String? eId,
    String? image,
    String? name,
    double? price,
    bool? returnKit,
  }) {
    return Product(
      id: id ?? this.id,
      eId: eId ?? this.eId,
      image: image ?? this.image,
      name: name ?? this.name,
      price: price ?? this.price,
      returnKit: returnKit??this.returnKit
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'eId': eId,
      'image': image,
      'name': name,
      'price': price,
      'returnKit':returnKit,
    };
  }

  factory Product.fromMap(DocumentSnapshot doc) {
    final Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      eId: map['eId'],
      image: map['image'],
      name: map['name'],
      price: map['price'].toDouble(),
      returnKit: map['returnKit']??false,
    );
  }

  factory Product.empty() {
    return Product(
      id: '',
      eId: '',
      image: '',
      name: '',
      price: 0,
      returnKit: false
    );
  }


  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product &&
        other.id == id &&
        other.eId == eId &&
        other.image == image &&
        other.name == name &&
        other.price == price;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        eId.hashCode ^
        image.hashCode ^
        name.hashCode ^
        price.hashCode;
  }
}
