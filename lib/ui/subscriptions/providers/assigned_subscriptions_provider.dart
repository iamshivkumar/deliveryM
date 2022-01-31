import 'package:delivery_m/core/models/dboy_day.dart';
import 'package:delivery_m/core/models/subscription.dart';
import 'package:delivery_m/core/repositories/subscription_repository_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final assignedSubscriptionsProvider =
    StreamProvider.family<List<Subscription>, DboyDay>(
  (ref, dboyDay) => ref
      .read(subscriptionRepositoryProvider)
      .dboyMonthSubscriptionsStream(dId: dboyDay.dId, month: dboyDay.date),
);
