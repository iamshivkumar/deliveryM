import '../../../core/models/subscription.dart';
import '../../../core/repositories/subscription_repository_provider.dart';
import '../../profile/providers/profile_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final customerSubscriptionsProvider =
    StreamProvider.family<List<Subscription>, String>(
  (ref, cId) =>
      ref.read(subscriptionRepositoryProvider).customerSubscriptionsStream(
            cId: cId,
            eId: ref.read(profileProvider).value!.id,
          ),
);
