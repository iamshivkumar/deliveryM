import 'package:cloud_firestore/cloud_firestore.dart';
import 'address.dart';

class Profile {
  final String id;
  final String firstname;
  final String lastname;
  final String mobile;
  final bool isAdmin;
  final Address address;
  final String eId;
  final bool active;
  final DateTime createdAt;
  final DateTime? end;
  final String? businessName;
  final List<String>? deboys;

  Profile({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.mobile,
    required this.createdAt,
    required this.isAdmin,
    required this.address,
    required this.eId,
    required this.active,
    this.deboys,
    this.end,
    this.businessName,
  });

  String get name => "$firstname $lastname";

  Profile copyWith({
    String? id,
    String? firstname,
    String? lastname,
    String? mobile,
    String? businessName,
    Address? address,
    String? eId,
    DateTime? createdAt,
    DateTime? end,
    bool? isAdmin,
    List<String>? deboys,
    bool? active,
  }) {
    return Profile(
      id: id ?? this.id,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      mobile: mobile ?? this.mobile,
      isAdmin: isAdmin ?? this.isAdmin,
      businessName: businessName ?? this.businessName,
      address: address ?? this.address,
      eId: eId ?? this.eId,
      end: end ?? this.end,
      createdAt: createdAt ?? this.createdAt,
      deboys: deboys ?? this.deboys,
      active: active ?? this.active,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstname': firstname,
      'lastname': lastname,
      'mobile': mobile,
      'isAdmin': isAdmin,
      'businessName': businessName,
      'address': address.toMap(),
      'eId':  eId,
      'createdAt': Timestamp.fromDate(createdAt),
      'end': end != null ? Timestamp.fromDate(end!) : null,
      'deboys': deboys,
      'active': active,
    }; 
  }

  factory Profile.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return Profile(
      id: doc.id,
      firstname: map['firstname'],
      lastname: map['lastname'],
      mobile: map['mobile'],
      businessName: map['businessName'],
      address: Address.fromMap(map['address']),
      eId: map['eId'],
      end: map['end']?.toDate(),
      createdAt: map['createdAt'].toDate(),
      isAdmin: map['isAdmin'],
      deboys: map['deboys'] != null ? List<String>.from(map['deboys']) : null,
      active: map['active'] ?? true,
    );
  }

  factory Profile.empty() {
    return Profile(
      id: '',
      firstname: '',
      lastname: '',
      mobile: '',
      address: Address.empty(),
      createdAt: DateTime.now(),
      isAdmin: false,
      eId: '',
      active: true,
    );
  }

  factory Profile.emptyAdmin() {
    return Profile(
      id: '',
      firstname: '',
      lastname: '',
      mobile: '',
      address: Address.empty(),
      createdAt: DateTime.now(),
      isAdmin: true,
      eId: '',
      end: DateTime.now().add(const Duration(days: 31)),
      deboys: [],
      active: true,
    );
  }

  bool get expired => end!.isBefore(DateTime.now());
}
