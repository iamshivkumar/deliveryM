import '../utils/auth_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final authProvider = ChangeNotifierProvider((ref) => Auth());

class Auth extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Stream<User?> get userStream => _auth.authStateChanges();

  String? verificationId;

  String _phone = '';
  String get phone => _phone;
  set phone(String phone) {
    _phone = phone;
    notifyListeners();
  }

  AuthMessage _authMessage = AuthMessage.empty();

  AuthMessage get authMessage => _authMessage;

  set authMessage(AuthMessage authMessage) {
    _authMessage = authMessage;
    notifyListeners();
  }

  String _code = '';
  String get code => _code;
  set code(String code) {
    _code = code;
    notifyListeners();
  }

  int? _resendToken;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  late Stream<int> stream;

  Stream<int> get _stream =>
      Stream.periodic(const Duration(seconds: 1), (v) => 30 - v);

  void sendOTP({
    required VoidCallback onSend,
    required VoidCallback onComplete,
  }) async {
    loading = true;
    try {
      await _auth.verifyPhoneNumber(
        forceResendingToken: _resendToken,
        phoneNumber: "+91" + phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          loading = true;
          // user = (
          await _auth.signInWithCredential(credential)
              // )
              // .user
              ;
          loading = false;
          onComplete();
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            if (kDebugMode) {
              print("The provided phone number is not valid.");
            }
          }
          loading = false;
        },
        timeout: const Duration(seconds: 30),
        codeAutoRetrievalTimeout: (_) {},
        codeSent: (String id, int? forceResendingToken) {
          verificationId = id;
          if (_resendToken != null) {
            authMessage = AuthMessage.otpResent();
          }
          _resendToken = forceResendingToken;

          stream = _stream;
          loading = false;
          onSend();
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      loading = false;
    }
  }

  Future<void> verifyOTP(
      {required VoidCallback clear, required VoidCallback onVerify}) async {
    loading = true;
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: code,
      );
      // user = (
      await _auth.signInWithCredential(credential)
          // ).user
          ;
      phone = '';
      onVerify();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        _authMessage = AuthMessage.incorrectOtp();
      }
      clear();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    loading = false;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    // user = null;
  }

  // void update() async {
  //   if (_auth.currentUser == null) {
  //     user!.reload();
  //   } else {
  //     _auth.currentUser!.reload();
  //     user = _auth.currentUser;
  //   }
  //   notifyListeners();
  // }
}
