import '../../../core/models/product.dart';
import '../../../core/models/profile.dart';
import '../../../core/repositories/products_repository_provider.dart';
import '../../profile/providers/profile_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final writeProductViewModelProvider =
    ChangeNotifierProvider((ref) => WriteProductViewModel(ref));

class WriteProductViewModel extends ChangeNotifier {
  final Ref _ref;
  WriteProductViewModel(this._ref);

  ProductsRepository get _repository => _ref.read(productsRepositoryProvider);

  Profile get _profile => _ref.read(profileProvider).value!;

  Product initial = Product.empty();

  bool get forEdit => initial.id.isNotEmpty;

  String? _image;
  String? get image => _image ?? initial.image;
  set image(String? image) {
    _image = image;
    notifyListeners();
  }

  String? _name;
  String get name => _name ?? initial.name;
  set name(String name) {
    _name = name;
  }

  double? _price;
  double get price => _price ?? initial.price;
  set price(double price) {
    _price = price;
  }

  bool? _returnKit;
  bool get returnKit => _returnKit ?? initial.returnKit;
  set returnKit(bool returnKit) {
    _returnKit = returnKit;
    notifyListeners();
  }

  void write() {
    final updated = initial.copyWith(
      image: image,
      name: name,
      price: price,
      eId: _profile.id,
      returnKit: returnKit,
    );
    try {
      _repository.write(updated);
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
    }
  }

  void clear() {
    _name = null;
    _image = null;
    _price = null;
    _returnKit = null;
    initial = Product.empty();
  }
}
