import 'package:delivery_m/core/models/master_data.dart';
import 'package:delivery_m/core/repositories/master_data_repository_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final masterDataProvider = FutureProvider<MasterData>(
  (ref) => ref.read(masterDataRepositoryProvider).masterDataFuture,
);
