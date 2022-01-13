import 'package:delivery_m/core/models/address.dart';
import 'package:delivery_m/core/models/profile.dart';
import 'package:delivery_m/core/repositories/profile_repository_provider.dart';
import 'package:delivery_m/ui/auth/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final registerViewModelProvider =
    ChangeNotifierProvider((ref) => RegisterViewModel(ref));

class RegisterViewModel extends ChangeNotifier {
  final Ref _ref;
  RegisterViewModel(this._ref);

  ProfileRepository get _repository => _ref.read(profileRepositoryProvider);


  Profile initial = Profile.empty();

  String? _firstname;
  String get firstname => _firstname ?? initial.firstname;
  set firstname(String firstname) {
    _firstname = firstname;
  }

  String? _lastname;
  String get lastname => _lastname ?? initial.lastname;
  set lastname(String lastname) {
    _lastname = lastname;
  }

  String? _businessName;
  String? get businessName => _businessName ?? initial.businessName;
  set businessName(String? businessName) {
    _businessName = businessName;
  }

  Address? _address;
  Address? get address => _address ?? initial.address;
  set address(Address? address) {
    _address = address;
    notifyListeners();
  }

  void register() async {
    final updated = initial.copyWith(
      firstname: firstname,
      lastname: lastname,
      businessName: businessName,
      isAdmin: true,
    );
    try {
      await _repository.writeProfile(updated);
    } catch (e) {
      print(e);
    }
  }
}
