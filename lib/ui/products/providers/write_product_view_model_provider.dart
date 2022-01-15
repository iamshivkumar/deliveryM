import 'package:delivery_m/core/models/product.dart';
import 'package:delivery_m/core/models/profile.dart';
import 'package:delivery_m/core/providers/master_data_provider.dart';
import 'package:delivery_m/core/repositories/products_repository_provider.dart';
import 'package:delivery_m/ui/profile/providers/profile_provider.dart';
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

  List<String> get images =>
      _ref.watch(masterDataProvider).asData?.value.images ?? [];
  

  bool get forEdit => initial.id.isNotEmpty;

  String? _image;
  String? get image =>
      _image ??
      (initial.image.isNotEmpty ? initial.image : null) ??
      (images.isNotEmpty ? images.first : null);
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

  void write() {
    final updated = initial.copyWith(
      image: image,
      name: name,
      price: price,
      eId: _profile.id,
    );
    try {
      _repository.write(updated);
    } catch (e) {
      print('$e');
    }
  }

  void clear(){
    _name = null;
    _image = null;
    _price = null;
    initial = Product.empty();
  }
}
