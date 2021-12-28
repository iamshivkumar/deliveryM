import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


final authProvider = Provider((ref)=>Auth());

class Auth {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<User?> get userStream => auth.authStateChanges();
}