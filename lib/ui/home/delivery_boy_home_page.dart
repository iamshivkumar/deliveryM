import 'package:delivery_m/core/models/profile.dart';
import 'package:delivery_m/core/repositories/gave_repository_provider.dart';
import 'package:delivery_m/ui/auth/providers/auth_provider.dart';
import 'package:delivery_m/ui/components/error.dart';
import 'package:delivery_m/ui/components/loading.dart';
import 'package:delivery_m/ui/deliveries/deliveries_page.dart';
import 'package:delivery_m/ui/home/providers/calendar_view_model_provider.dart';
import 'package:delivery_m/ui/home/providers/dboy_day_subscriptions_provider.dart';
import 'package:delivery_m/ui/home/widgets/give_sheet.dart';
import 'package:delivery_m/ui/home/widgets/my_calendar.dart';
import 'package:delivery_m/ui/products/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'providers/gave_provider.dart';
import 'utils/calc.dart';
import 'widgets/big_ana_card.dart';

class DeliveryBoyHomePage extends ConsumerWidget {
  const DeliveryBoyHomePage({Key? key, required this.profile})
      : super(key: key);
  final Profile profile;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final model = ref.watch(calendarViewModelProvider);
    final gaveStream = ref.watch(gaveProvider(model.selectedDate));

    final productsStream = ref.watch(productsProvider);
    final subscriptionStream = ref.watch(dboyDaySubscriptionsProvider(
        DboyDay(dId: profile.id, date: model.selectedDate)));
    final _repository = ref.read(gaveRepositoryProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shivkumar Konade'),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(authProvider).signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DeliveriesPage(),
            ),
          );
        },
        label: const Text('Continue Deliveries'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            expandedHeight: (width / 2.65),
            floating: true,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: MyCalendar(),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(4),
            sliver: SliverList(
              delegate: SliverChildListDelegate(gaveStream.when(
                data: (gave) => productsStream.when(
                  data: (products) => subscriptionStream.when(
                    data: (subscriptions) {
                      final calc =
                          Calc(list: subscriptions, date: model.selectedDate);
                      return products
                          .map(
                            (e) => BigAnaCard(
                              product: e,
                              delivered: calc.deliveredByD(e.id, profile.id),
                              estimated: calc.estimatedByD(e.id, profile.id),
                              pending: calc.pendingByD(e.id, profile.id),
                              gave: gave.gaveToD(e.id, profile.id),
                              onTap: () async {
                                final int? quantity =
                                    await showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) => GiveSheet(
                                      initial: gave.gaveToD(e.id, profile.id),
                                      product: e),
                                );
                                if (quantity != null) {
                                  try {
                                    _repository.give(
                                    id: gave.id,
                                    dId: profile.id,
                                    pId: e.id,
                                    quantity: quantity,
                                  );
                                  } catch (e) {
                                    print('$e');
                                  }
                                }
                              },
                            ),
                          )
                          .toList();
                    },
                    error: (e, s) => [DataError(e: e)],
                    loading: () => [const Loading()],
                  ),
                  error: (e, s) => [DataError(e: e)],
                  loading: () => [const Loading()],
                ),
                error: (e, s) => [DataError(e: e)],
                loading: () => [const Loading()],
              )),
            ),
          ),
        ],
      ),
    );
  }
}
