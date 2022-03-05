import 'package:delivery_m/core/providers/master_data_provider.dart';
import 'package:delivery_m/ui/components/version_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final rootViewModelProvider =
    Provider.family<void, BuildContext>((ref, context) {
  ref.watch(masterDataProvider).whenData((value) {
    if (value.versionCode > 2) {
      showDialog(
          context: context,
          builder: (context) => VersionDialog(forced: value.forced),
        );
    }
  });
});


