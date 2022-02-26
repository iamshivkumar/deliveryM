import 'package:cloud_firestore/cloud_firestore.dart';

class MasterData {
  final double price;
  MasterData({
    required this.price,
  });

  factory MasterData.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return MasterData(
      price: map['price'].toDouble(),
    );
  }
}
