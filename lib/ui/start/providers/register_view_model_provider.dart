import 'package:delivery_m/core/models/address.dart';
import 'package:delivery_m/core/models/profile.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final registerViewModelProvider = ChangeNotifierProvider((ref)=>RegisterViewModel(ref));

class RegisterViewModel extends ChangeNotifier{
  final Ref ref;
  RegisterViewModel(this.ref);
  
  Profile initial = Profile.empty();

  String? _firstname;
  String get firstname => _firstname??initial.firstname;
  set firstname(String firstname) {
    _firstname = firstname;
  }

  String? _lastname;
  String get lastname => _lastname??initial.lastname;
  set lastname(String lastname) {
    _lastname = lastname;
  }

  String? _businessName;
  String? get businessName => _businessName??initial.businessName;
  set businessName(String? businessName) {
    _businessName = businessName;
  }

  Address? _address;
  Address? get address => _address??initial.address;
  set address(Address? address) {
    _address = address;
    notifyListeners();
  }

}