import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import '../../utils/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final productsRepositoryProvider =
    Provider<ProductsRepository>((ref) => ProductsRepository());

class ProductsRepository {
  final _firestore = FirebaseFirestore.instance;

  void write(Product product) {
    if (product.id.isEmpty) {
      _firestore.collection(Constants.products).add(product.toMap());
    } else {
      _firestore
          .collection(Constants.products)
          .doc(product.id)
          .update(product.toMap());
    }
  }

  Stream<List<Product>> productsStream(String eid) =>
      _firestore.collection(Constants.products).where(Constants.eId,isEqualTo: eid).snapshots().map(
            (event) => event.docs.map((e) => Product.fromMap(e)).toList(),
          );

  void delete(String id){
    _firestore.collection(Constants.products).doc(id).delete();
  }
}
