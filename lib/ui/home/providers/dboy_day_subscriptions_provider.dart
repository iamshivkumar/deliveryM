import 'package:delivery_m/core/models/dboy_day.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/models/subscription.dart';
import '../../../core/repositories/subscription_repository_provider.dart';

final dboyDaySubscriptionsProvider =
    StreamProvider.family<List<Subscription>, DboyDay>(
  (ref, dboyDay) =>
      ref.read(subscriptionRepositoryProvider).dboyDaySubscriptionsStream(
            dId: dboyDay.dId,
            date: dboyDay.date,
          ),
);
