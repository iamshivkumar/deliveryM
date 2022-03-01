import 'package:delivery_m/core/providers/master_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final rootViewModelProvider = Provider.family<RootViewModel, BuildContext>(
    (ref, context) => RootViewModel(ref, context));

class RootViewModel {
  final BuildContext context;
  final Ref _ref;

  RootViewModel(
    this._ref,
    this.context,
  );

  void init() {
    _ref.watch(masterDataProvider).whenData((value) {
      if (value.versionCode>1) {
        
      }
    });
  }
}
