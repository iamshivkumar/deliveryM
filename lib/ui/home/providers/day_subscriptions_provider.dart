import 'package:delivery_m/core/models/subscription.dart';
import 'package:delivery_m/core/repositories/subscription_repository_provider.dart';
import 'package:delivery_m/ui/profile/providers/profile_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final daySubscriptionsProvider = StreamProvider.family<List<Subscription>,DateTime>(
  (ref,date) => ref.read(subscriptionRepositoryProvider).daySubscriptionsStream(
        eId: ref.watch(profileProvider).value!.id,
        date: date,
      ),
);
