import '../../../core/models/profile.dart';
import '../../../core/repositories/profile_repository_provider.dart';
import '../../auth/providers/user_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final profileProvider = StreamProvider<Profile?>(
  (ref) {
    final id = ref.watch(userProvider).asData?.value?.uid;
    if (id == null) {
      return Stream.error('User not authorised!');
    } else {
      return ref.read(profileRepositoryProvider).profileStream(id);
    }
  },
);
