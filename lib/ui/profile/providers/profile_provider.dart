import 'package:delivery_m/core/models/profile.dart';
import 'package:delivery_m/core/repositories/profile_repository_provider.dart';
import 'package:delivery_m/ui/auth/providers/user_provider.dart';
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
