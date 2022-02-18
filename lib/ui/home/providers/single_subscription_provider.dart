import 'package:delivery_m/core/repositories/subscription_repository_provider.dart';
import 'package:delivery_m/ui/profile/providers/profile_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final isSubscriptionExistProvider = StreamProvider<bool>(
  (ref) => ref.read(subscriptionRepositoryProvider).isSubscriptionExist(
        ref.watch(profileProvider).value!.eId,
      ),
);
