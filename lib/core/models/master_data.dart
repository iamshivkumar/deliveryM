import 'package:cloud_firestore/cloud_firestore.dart';

class MasterData {
  final double price;
  final int versionCode;
  final bool forced;
  MasterData({
    required this.price,
    required this.versionCode,
    required this.forced
  });

  factory MasterData.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return MasterData(
      price: map['price'].toDouble(),
      versionCode: map['versionCode'].toInt(),
      forced: map['forced'],
    );
  }
}
