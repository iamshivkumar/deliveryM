import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/gave.dart';
import '../../utils/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final gaveRepositoryProvider = Provider((ref) => GaveRepository());

class GaveRepository {
  final _firestore = FirebaseFirestore.instance;

  Stream<Gave> gaveStream({required String eId, required DateTime date}) {
    return _firestore
        .collection(Constants.gaves)
        .where(Constants.eId, isEqualTo: eId)
        .where(Constants.createdAt, isEqualTo: date)
        .snapshots()
        .map((event) {
      if (event.docs.isEmpty) {
        final updated = Gave(id: '', eId: eId, data: {}, createdAt: date);
        _firestore.collection(Constants.gaves).add(updated.toMap());
        return updated;
      } else {
        return Gave.fromFirestore(event.docs.first);
      }
    });
  }

  void give(
      {required String id,
      required String dId,
      required String pId,
      required int quantity}) {
    _firestore.collection(Constants.gaves).doc(id).update({
      pId: FieldValue.increment(quantity),
      '${pId}_$dId': FieldValue.increment(quantity),
    });
  }
}
