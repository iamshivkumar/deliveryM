import '../../../core/enums/delivery_status.dart';
import '../../../core/models/subscription.dart';
import '../utils/generate.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'delivery_card.dart';

class DeliveriesListView extends ConsumerWidget {
  const DeliveriesListView(
      {Key? key, required this.date, required this.subscriptions})
      : super(key: key);
  final DateTime date;
  final List<Subscription> subscriptions;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TabBarView(
      children: [
        DeliveryStatus.pending,
        DeliveryStatus.delivered,
        DeliveryStatus.canceled
      ].map(
        (e) {
          final generate =
              Generate(date: date, subscriptions: subscriptions, status: e);
          return ListView(
            padding: const EdgeInsets.all(4),
            children: generate.stats
                .map(
                  (e) => DeliveryCard(deliveryStat: e),
                )
                .toList(),
          );
        },
      ).toList(),
    );
  }
}
