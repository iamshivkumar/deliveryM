import 'package:delivery_m/core/models/dboy_day.dart';
import 'package:delivery_m/ui/deliveries/widgets/map_view.dart';
import 'package:delivery_m/utils/assets.dart';

import '../components/error.dart';
import '../components/loading.dart';
import 'widgets/deliveries_list_view.dart';
import '../home/providers/dboy_day_subscriptions_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final mapviewProvider = StateProvider<bool>((ref) => false);

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
    final mapview = ref.watch(mapviewProvider.state);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Deliveries'),
          actions: [
            Transform.translate(
              offset: const Offset(8, 0),
              child: SizedBox(
                height: 28,
                width: 28,
                child: Image.asset(Assets.googleMap),
              ),
            ),
            Switch(
              value: mapview.state,
              onChanged: (v) {
                mapview.state = v;
              },
            ),
          ],
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
          data: (subscriptions) => mapview.state
              ? MapView(
                  date: dboyDay.date,
                  subscriptions: subscriptions,
                )
              : DeliveriesListView(
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
