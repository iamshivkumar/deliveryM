import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_m/core/models/address.dart';

class Profile {
  final String id;
  final String firstname;
  final String lastname;
  final String mobile;
  final bool isAdmin;

  final DateTime createdAt;
  final DateTime? end;
  final String? businessName;
  final List<String>? deboys;

  final Address? address;
  final String? businessId;

  Profile({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.mobile,
    required this.createdAt,
    required this.isAdmin,
    this.deboys,
    this.end,
    this.businessName,
    this.address,
    this.businessId,
  });

  Profile copyWith({
    String? id,
    String? firstname,
    String? lastname,
    String? mobile,
    String? businessName,
    Address? address,
    String? businessId,
    DateTime? createdAt,
    DateTime? end,
    bool? isAdmin,
    List<String>? deboys,
  }) {
    return Profile(
      id: id ?? this.id,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      mobile: mobile ?? this.mobile,
      isAdmin: isAdmin ?? this.isAdmin,
      businessName: businessName ?? this.businessName,
      address: address ?? this.address,
      businessId: businessId ?? this.businessId,
      end: end ?? this.end,
      createdAt: createdAt ?? this.createdAt,
      deboys: deboys??this.deboys,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstname': firstname,
      'lastname': lastname,
      'mobile': mobile,
      'isAdmin': isAdmin,
      'businessName': businessName,
      'address': address?.toMap(),
      'businessId': businessId,
      'createdAt': Timestamp.fromDate(createdAt),
      'end': end != null ? Timestamp.fromDate(end!) : null,
      'deboys': deboys
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
      address: map['address'] != null ? Address.fromMap(map['address']) : null,
      businessId: map['businessId'],
      end: map['end']?.toDate(),
      createdAt: map['createdAt'].toDate(),
      isAdmin: map['isAdmin'],
      deboys: map['deboys']!=null? List<String>.from(map['deboys']):null,
    );
  }

  factory Profile.empty() {
    return Profile(
      id: '',
      firstname: '',
      lastname: '',
      mobile: '',
      createdAt: DateTime.now(),
      isAdmin: true,
    );
  }
}


///name
///role
///phone?

///business? name
///business? address
///delivery boys emails or phone numbers?

///business ID? 
