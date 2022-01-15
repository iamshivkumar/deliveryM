import 'package:cloud_firestore/cloud_firestore.dart';

class MasterData {
  final List<String> images;
  MasterData({
    required this.images,
  });

  factory MasterData.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return MasterData(
      images: List<String>.from(map['images']),
    );
  }
}
