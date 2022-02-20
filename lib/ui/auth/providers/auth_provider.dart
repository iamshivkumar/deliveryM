import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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

  String? _verificationId;
  String? get verificationId => _verificationId;
  set verificationId(String? verificationId) {
    _verificationId = verificationId;
    notifyListeners();
  }

  String _phone = '';
  String get phone => _phone;
  set phone(String phone) {
    _phone = phone;
    _code = '';
    resendToken = null;
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

  int? resendToken;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

    bool _phoneLoading = false;
  bool get phoneLoading => _phoneLoading;
  set phoneLoading(bool value) {
    _phoneLoading = value;
    notifyListeners();
  }

  late Stream<int> stream;

  Stream<int> get _stream =>
      Stream.periodic(const Duration(seconds: 1), (v) => 30 - v);

  void sendOTP() async {
    phoneLoading = true;
    try {
      await _auth.verifyPhoneNumber(
        forceResendingToken: resendToken,
        phoneNumber: "+91" + phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          loading = true;
          await _auth.signInWithCredential(credential);
          loading = false;
          verificationId = null;
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            if (kDebugMode) {
              print("The provided phone number is not valid.");
            }
          }
          phoneLoading = false;
        },
        timeout: const Duration(seconds: 30),
        codeAutoRetrievalTimeout: (_) {},
        codeSent: (String id, int? forceResendingToken) {
          verificationId = id;
          if (resendToken != null) {
            authMessage = AuthMessage.otpResent();
          }
          resendToken = forceResendingToken;
          stream = _stream;
          phoneLoading = false;
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      phoneLoading = false;
    }
  }

  Future<void> verifyOTP(
      {required VoidCallback clear}) async {
    loading = true;
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: code,
      );
      await _auth.signInWithCredential(credential);
      phone = '';
      verificationId = null;
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


    final formater = MaskTextInputFormatter(
    mask: '##########',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.eager,
  );
  final otpformater = MaskTextInputFormatter(
                    mask: '#   #   #   #   #   #',
                    filter: {"#": RegExp(r'[0-9]')},
                    type: MaskAutoCompletionType.lazy,
                  );

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
