import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_m/core/models/wallet_transaction.dart';
import 'package:delivery_m/core/repositories/subscription_repository_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final customerTransactionsViewModelProvider =
    ChangeNotifierProvider.family<CustomerTransactionsViewModel, String>(
  (ref, id) {
    final model = CustomerTransactionsViewModel(ref, id);
    model.init();
    return model;
  },
);

class CustomerTransactionsViewModel extends ChangeNotifier {
  final Ref _ref;
  final String id;
  CustomerTransactionsViewModel(this._ref, this.id);

  SubscriptionRepository get _repository =>
      _ref.read(subscriptionRepositoryProvider);

  List<WalletTransaction> updatedRates = [];

  List<DocumentSnapshot> _snapshots = [];
  List<WalletTransaction> get transactions => _snapshots
      .map(
        (e) => WalletTransaction.fromMap(e),
      )
      .toList();

  Future<void> init() async {
    try {
      _snapshots = await _repository.reviewsLimitFuture(limit: 10, cId: id);
      initLoading = false;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  bool initLoading = true;

  bool loading = true;
  bool busy = false;

  Future<void> loadMore() async {
    busy = true;
    var previous = _snapshots;
    try {
      _snapshots = _snapshots +
          await _repository.reviewsLimitFuture(
            cId: id,
            limit: 6,
            last: _snapshots.last,
          );
      if (_snapshots.length == previous.length) {
        loading = false;
      } else {
        loading = true;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    busy = false;
    notifyListeners();
  }
}
