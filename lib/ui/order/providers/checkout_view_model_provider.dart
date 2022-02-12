import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_m/core/enums/payment_status.dart';
import 'package:delivery_m/core/models/profile.dart';
import 'package:delivery_m/core/repositories/order_repository_provider.dart';
import 'package:delivery_m/ui/profile/providers/profile_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

final checkoutViewModelProvider =
    ChangeNotifierProvider((ref) => CheckoutViewModel(ref));

class CheckoutViewModel extends ChangeNotifier {
  final Ref _ref;

  CheckoutViewModel(this._ref);

  OrderRepository get _repository => _ref.read(orderRepositoryProvider);

  Profile get _profile => _ref.read(profileProvider).value!;

  final _razorpay = Razorpay();

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  void checkout({String? orderId, required double amount}) async {
    late String id;
    if (orderId != null) {
      id = orderId;
    } else {
      try {
        id = await _repository.createOrder(uid: _profile.id, amount: amount);
      } catch (e) {
        if (kDebugMode) {
          print('$e');
        }
        return;
      }
    }
    try {
      final options = {
        'key': 'rzp_test_KmPzyFK6pErbkC',
        'amount': (amount * 100).toInt(),
        'name': 'Subscription Charge',
        'description': 'Pay For Checkout',
        'order_id': id,
        'prefill': {
          'contact': _profile.mobile,
        }
      };
      if (kDebugMode) {
        print("option created");
      }
      _razorpay.open(options);
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
          (PaymentSuccessResponse res) async {
        _razorpay.clear();
        if (kDebugMode) {
          print("listened success");
        }
        try {
          await _repository.update(
            map: {
              'paymentId': res.paymentId,
              'signature': res.signature,
              'paymentStatus': PaymentStatus.success,
              'createdAt': Timestamp.now(),
            },
            id: id,
          );
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
        if (kDebugMode) {
          print("order updated");
        }
        loading = false;
      });
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
          (PaymentFailureResponse res) async {
        if (kDebugMode) {
          print("listened updated");
        }
        _razorpay.clear();
        try {
          await _repository.update(
            id: id,
            map: {
              'paymentStatus': PaymentStatus.failed,
            },
          );
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
        loading = false;
      });
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
          (ExternalWalletResponse res) {
        _razorpay.clear();
        _repository.update(
          map: {
            'paymentMethod': res.walletName,
          },
          id: id,
        );
      });
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
    }
  }
}
