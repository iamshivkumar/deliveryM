import '../models/master_data.dart';
import '../repositories/master_data_repository_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final masterDataProvider = FutureProvider<MasterData>(
  (ref) => ref.read(masterDataRepositoryProvider).masterDataFuture,
);
