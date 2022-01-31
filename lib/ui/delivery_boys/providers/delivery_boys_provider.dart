import 'package:delivery_m/core/models/profile.dart';

import '../../../core/repositories/profile_repository_provider.dart';
import '../../profile/providers/profile_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final delilveryBoysProvider = StreamProvider<List<Profile>>(
  (ref) => ref.read(profileRepositoryProvider).dboysStream(
        ref.watch(profileProvider).value!.id,
      ),
);
