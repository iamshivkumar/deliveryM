
import 'package:cloud_firestore/cloud_firestore.dart';


class Gave {
  final String id;
  final String eId;
  final Map<String, dynamic> data;
  final DateTime createdAt;

  Gave({
    required this.id,
    required this.eId,
    required this.data,
    required this.createdAt,
  });

  Gave copyWith({
    String? id,
    String? eId,
    Map<String, dynamic>? data,
    DateTime? createdAt,
  }) {
    return Gave(
      id: id ?? this.id,
      eId: eId ?? this.eId,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'eId': eId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory Gave.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return Gave(
        id: doc.id, eId: map['eId'], data: map, createdAt: map['createdAt'].toDate());
  }

  int gave(String pId) => (data[pId] as int?) ?? 0;
  int gaveToD(String pId, String dId) => (data["${pId}_$dId"] as int?) ?? 0;

}
