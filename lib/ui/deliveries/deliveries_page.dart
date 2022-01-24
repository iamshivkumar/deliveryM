import 'package:delivery_m/ui/components/error.dart';
import 'package:delivery_m/ui/components/loading.dart';
import 'package:delivery_m/ui/deliveries/widgets/deliveries_list_view.dart';
import 'package:delivery_m/ui/home/providers/dboy_day_subscriptions_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DeliveriesPage extends ConsumerWidget {
  const DeliveriesPage({
    Key? key,
    required this.dboyDay,
  }) : super(key: key);

  final DboyDay dboyDay;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionsStream =
        ref.watch(dboyDaySubscriptionsProvider(dboyDay));
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Deliveries'),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'Pending',
              ),
              Tab(
                text: 'Delivered',
              ),
              Tab(
                text: 'Cancelled',
              ),
            ],
          ),
        ),
        body: subscriptionsStream.when(
          data: (subscriptions) => DeliveriesListView(
            date: dboyDay.date,
            subscriptions: subscriptions,
          ),
          error: (e, s) => DataError(e: e),
          loading: () => const Loading(),
        ),
      ),
    );
  }
}
