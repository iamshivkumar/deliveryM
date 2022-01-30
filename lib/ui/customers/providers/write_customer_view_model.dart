import 'dart:io';

import '../../../core/models/address.dart';
import '../../../core/models/customer.dart';
import '../../../core/models/profile.dart';
import '../../../core/repositories/customers_repository_provider.dart';
import '../../profile/providers/profile_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final writeCustomerViewModelProvider =
    ChangeNotifierProvider((ref) => WriteCustomerViewModel(ref));

class WriteCustomerViewModel extends ChangeNotifier {
  final Ref _ref;
  WriteCustomerViewModel(this._ref);

  CustomersRepository get _repository => _ref.read(customersRepositoryProvider);

  Profile get _profile => _ref.read(profileProvider).value!;

  Customer initial = Customer.empty();


  

  bool get forEdit => initial.id.isNotEmpty;

  void removeDoc(String doc){
    initial.documents.remove(doc);
    notifyListeners();
  }

  List<File> files = [];

  void addFile(File file){
    files.add(file);
    notifyListeners();
  }

  void removeFile(File file){
    files.remove(file);
    notifyListeners();
  }

  String? _name;
  String get name => _name ?? initial.name;
  set name(String name) {
    _name = name;
  }

  String? _mobile;
  String get mobile => _mobile??initial.mobile;
  set mobile(String mobile) {
    _mobile = mobile;
  }

  Address? _address;
  Address? get address => _address??(initial.address.isEmpty?null:initial.address);
  set address(Address? address) {
    _address = address;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  void write({required VoidCallback onDone})async {
    loading = true;
    final updated = initial.copyWith(
      name: name,
      eId: _profile.id,
      address: address,
      mobile: mobile
    );
    try {
     await _repository.write(updated,files: files);
     onDone();
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
      loading = false;
    }
  }

  void clear(){
    _name = null;
    _mobile = null;
    _address = null;
    _loading = false;
    files = [];
    initial = Customer.empty();
  }
}
