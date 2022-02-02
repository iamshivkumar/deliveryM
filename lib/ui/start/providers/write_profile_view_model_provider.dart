import '../../../core/models/address.dart';
import '../../../core/models/profile.dart';
import '../../../core/repositories/profile_repository_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final writeProfileViewModelProvider =
    ChangeNotifierProvider((ref) => WriteProfileViewModel(ref));

class WriteProfileViewModel extends ChangeNotifier {
  final Ref _ref;
  WriteProfileViewModel(this._ref);

  ProfileRepository get _repository => _ref.read(profileRepositoryProvider);


  Profile initial = Profile.empty();

  bool get forEdit => initial.id.isNotEmpty;

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
  Address? get address => _address??(initial.address.isEmpty?null:initial.address);
  set address(Address? address) {
    _address = address;
    notifyListeners();
  }

  void clear(){
    _address = null;
    _lastname = null;
    _businessName = null;
    _firstname = null;
    initial = Profile.empty();
  }

  void register() async {
    final updated = initial.copyWith(
      firstname: firstname,
      lastname: lastname,
      businessName: businessName,
      isAdmin: true,
      address: address,
      deboys: [],
    );
    try {
      await _repository.writeProfile(updated);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
