import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_m/core/models/customer.dart';
import 'package:delivery_m/utils/constants.dart';
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

  Stream<List<Customer>> customersStream(String eid) =>
      _firestore.collection(Constants.customers).where(Constants.eId,isEqualTo: eid).snapshots().map(
            (event) => event.docs.map((e) => Customer.fromFirestore(e)).toList(),
          );

  void delete(String id) {
    _firestore.collection(Constants.customers).doc(id).delete();
  }

  Future<String> _uploadImage( File file) async {
    final task = await _storage
        .ref('documents')
        .child('${DateTime.now().millisecondsSinceEpoch}')
        .putFile(file);
    return await task.ref.getDownloadURL();
  }
}
