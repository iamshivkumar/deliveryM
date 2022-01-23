import 'package:equatable/equatable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:delivery_m/core/models/subscription.dart';
import 'package:delivery_m/core/repositories/subscription_repository_provider.dart';

class DboyDay extends Equatable {
  final String dId;
  final DateTime date;

  const DboyDay({
    required this.dId,
    required this.date,
  });

  @override
  List<Object?> get props => [dId, date];
}

final dboyDaySubscriptionsProvider =
    StreamProvider.family<List<Subscription>, DboyDay>(
  (ref, dboyDay) =>
      ref.read(subscriptionRepositoryProvider).dboyDaySubscriptionsStream(
            dId: dboyDay.dId,
            date: dboyDay.date,
          ),
);
