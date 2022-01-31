import 'package:delivery_m/core/models/subscription.dart';
import 'package:delivery_m/core/repositories/subscription_repository_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final subscriptionProvider = StreamProvider.family<Subscription, String>(
  (ref, sId) =>
      ref.read(subscriptionRepositoryProvider).subscriptionStream(sId),
);
