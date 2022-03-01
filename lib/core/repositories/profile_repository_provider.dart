import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_m/core/models/address.dart';
import '../models/profile.dart';
import '../../ui/auth/providers/user_provider.dart';
import '../../utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final profileRepositoryProvider = Provider((ref) => ProfileRepository(ref));

class ProfileRepository {
  final Ref _ref;
  ProfileRepository(this._ref);

  final _firestore = FirebaseFirestore.instance;

  User get _user => _ref.read(userProvider).value!;

  Future<void> writeProfile(
    Profile profile,
  ) async {
    if (profile.id.isNotEmpty) {
      await _firestore
          .collection(Constants.users)
          .doc(profile.id)
          .update(profile.toMap());
    } else {
      final _batch = _firestore.batch();
      _batch.set(
          _firestore.collection(Constants.users).doc(_user.uid),
          profile
              .copyWith(
                mobile: _user.phoneNumber,
                eId: profile.isAdmin? _user.uid: null,
              )
              .toMap(),SetOptions(merge: true));
      if (!profile.isAdmin) {
        _batch.update(_firestore.collection(Constants.users).doc(profile.eId), {
          Constants.deboys: FieldValue.arrayRemove([profile.mobile])
        });
      }
      _batch.commit();
    }
  }

  void removeDboyMobile({required String mobile, required String eId}) {
    _firestore.collection(Constants.users).doc(eId).update({
      Constants.deboys: FieldValue.arrayRemove([mobile])
    });
  }

  Stream<Profile?> profileStream(String id) =>
      _firestore.collection(Constants.users).doc(id).snapshots().map(
            (event) => event.exists ? Profile.fromFirestore(event) : null,
          );

  void addDeliveryBoy(String mobile) {
    _firestore.collection(Constants.users).doc(_user.uid).update({
      Constants.deboys: FieldValue.arrayUnion([mobile])
    });
  }

  Future<List<Profile>> businessesFuture(String mobile) {
    return _firestore
        .collection(Constants.users)
        .where(Constants.deboys, arrayContains: mobile)
        .get()
        .then(
          (value) => value.docs.map((e) => Profile.fromFirestore(e)).toList(),
        );
  }

  Stream<List<Profile>> dboysStream(String id) {
    return _firestore
        .collection(Constants.users)
        .where(Constants.eId, isEqualTo: id)
        .snapshots()
        .map(
          (value) => value.docs
              .map(
                (e) => Profile.fromFirestore(e),
              )
              .toList(),
        );
  }

  void updateAddress({required String dId, required Address address}) {
    _firestore.collection(Constants.users).doc(dId).update({
      Constants.address: address.toMap(),
    });
  }

  void updateDeliveryBoyStatus({required String dId, required bool value}) {
    _firestore.collection(Constants.users).doc(dId).update({
      Constants.active: value,
    });
  }
}
