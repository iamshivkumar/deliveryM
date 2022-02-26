import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/master_data.dart';
import '../../utils/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final masterDataRepositoryProvider = Provider((ref) => MasterDataRepository());

class MasterDataRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<MasterData> get masterDataFuture async => await _firestore
      .collection(Constants.masterData)
      .doc(Constants.masterDataV1)
      .get()
      .then(
        (value) => MasterData.fromFirestore(value),
      );
}
