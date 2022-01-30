import '../../../core/repositories/profile_repository_provider.dart';
import '../../auth/providers/user_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final bussinessesProvider = FutureProvider(
  (ref) => ref
      .read(profileRepositoryProvider)
      .businessesFuture(ref.watch(userProvider).value!.phoneNumber!),
);
