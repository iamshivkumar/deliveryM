import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_m/core/models/wallet_transaction.dart';
import '../models/address.dart';
import '../models/customer.dart';
import '../../utils/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final customersRepositoryProvider =
    Provider<CustomersRepository>((ref) => CustomersRepository());

class CustomersRepository {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<void> write(Customer customer, {required List<File> files}) async {
    for (var file in files) {
      customer.documents.add(await _uploadImage(file));
    }
    if (customer.id.isEmpty) {
      await _firestore.collection(Constants.customers).add(customer.toMap());
    } else {
      await _firestore
          .collection(Constants.customers)
          .doc(customer.id)
          .update(customer.toMap());
    }
  }

  Stream<List<Customer>> customersStream(String eid) => _firestore
      .collection(Constants.customers)
      .where(Constants.eId, isEqualTo: eid)
      .snapshots()
      .map(
        (event) => event.docs.map((e) => Customer.fromFirestore(e)).toList(),
      );

  void delete(String id) {
    _firestore.collection(Constants.customers).doc(id).delete();
  }

  Future<String> _uploadImage(File file) async {
    final task = await _storage
        .ref('documents')
        .child('${DateTime.now().millisecondsSinceEpoch}')
        .putFile(file);
    return await task.ref.getDownloadURL();
  }

  Stream<Customer> customerFuture(String id) {
    return _firestore.collection(Constants.customers).doc(id).snapshots().map(
          (value) => Customer.fromFirestore(value),
        );
  }

  void addBalance(
      {required String cId, required double amount, required double balance}) {
    final _batch = _firestore.batch();
    _batch.update(_firestore.collection(Constants.customers).doc(cId), {
      Constants.balance: FieldValue.increment(amount),
    });
    _batch.set(
      _firestore.collection(Constants.walletTransactions).doc(),
      WalletTransaction(
        id: '',
        cId: cId,
        amount: amount,
        createdAt: DateTime.now(),
        balance: balance + amount,
      ).toMap(),
    );
    _batch.commit();
  }

  void updateAddress({required String cId, required Address address}) {
    _firestore.collection(Constants.customers).doc(cId).update({
      Constants.address: address.toMap(),
    });
  }
}
