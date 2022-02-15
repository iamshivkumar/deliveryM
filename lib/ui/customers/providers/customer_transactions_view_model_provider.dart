import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_m/core/models/customer.dart';
import 'package:delivery_m/core/models/wallet_transaction.dart';
import 'package:delivery_m/core/repositories/subscription_repository_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/models/profile.dart';
import '../../pdf/providers/generate_pdf_view_model_provider.dart';
import '../../profile/providers/profile_provider.dart';
import 'customers_provider.dart';

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
      _snapshots =
          await _repository.walletTransactionsLimitFuture(limit: 10, cId: id);
      if (kDebugMode) {
        print(_snapshots.length);
      }
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
          await _repository.walletTransactionsLimitFuture(
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

  Customer get _customer =>
      _ref.watch(customersProvider).value!.where((e) => e.id == id).first;
  Profile get _profile => _ref.read(profileProvider).value!;

  void generate({
    required Function(File) onDone,
  }) async {
    try {
      final file = await GeneratePdf.generateTransactionsHistory(
        transactions: transactions,
        customer: _customer,
        name: _profile.businessName!,
      );
      onDone(file);
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
    }
  }
}
