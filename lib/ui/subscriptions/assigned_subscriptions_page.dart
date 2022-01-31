import 'package:delivery_m/core/models/dboy_day.dart';
import 'package:delivery_m/ui/components/error.dart';
import 'package:delivery_m/ui/components/loading.dart';
import 'package:delivery_m/ui/subscriptions/providers/assigned_subscriptions_provider.dart';
import 'package:delivery_m/ui/subscriptions/providers/diff_provider.dart';
import 'package:delivery_m/ui/subscriptions/widgets/subscription_card.dart';
import 'package:delivery_m/utils/dates.dart';
import 'package:delivery_m/utils/formats.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AssignedSubscriptionsPage extends ConsumerWidget {
  const AssignedSubscriptionsPage({
    Key? key,
    required this.dId,
    required this.dName,
  }) : super(key: key);

  final String dId;
  final String dName;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final diff = ref.watch(diffProvider.state);
    final date = DateTime(Dates.today.year, Dates.today.month + diff.state);
    final subscriptionsStream = ref.watch(
      assignedSubscriptionsProvider(
        DboyDay(dId: dId, date: date),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(dName),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  diff.state--;
                },
                icon: const Icon(Icons.keyboard_arrow_left),
              ),
              RichText(
                text: TextSpan(
                    text: "Started in ",
                    style: style.caption,
                    children: [
                      TextSpan(
                        text: Formats.month(date),
                        style: style.subtitle2,
                      )
                    ]),
              ),
              IconButton(
                onPressed: () {
                  diff.state++;
                },
                icon: const Icon(Icons.keyboard_arrow_right),
              ),
            ],
          ),
        ),
      ),
      body: subscriptionsStream.when(
        data: (subscriptions) => ListView(
          children: subscriptions
              .map(
                (e) => SubscriptionCard(subscription: e),
              )
              .toList(),
        ),
        error: (e, s) => DataError(e: e),
        loading: () => const Loading(),
      ),
    );
  }
}
