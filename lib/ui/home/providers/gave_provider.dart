import 'package:delivery_m/core/models/gave.dart';
import 'package:delivery_m/core/repositories/gave_repository_provider.dart';
import 'package:delivery_m/ui/profile/providers/profile_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final gaveProvider = StreamProvider.family<Gave, DateTime>(
  (ref, date) => ref
      .read(gaveRepositoryProvider)
      .gaveStream(eId: ref.watch(profileProvider).value!.eId, date: date),
);
