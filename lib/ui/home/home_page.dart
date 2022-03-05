import 'package:delivery_m/ui/customers/customers_page.dart';
import 'package:delivery_m/ui/home/providers/single_subscription_provider.dart';
import 'package:delivery_m/ui/products/products_page.dart';
import 'package:delivery_m/ui/profile/profile_page.dart';
import 'package:delivery_m/utils/assets.dart';

import '../../core/models/product.dart';
import '../../utils/labels.dart';
import '../components/error.dart';
import '../components/loading.dart';
import '../components/logo_title.dart';
import 'delivery_boy_home_page.dart';
import 'providers/calendar_view_model_provider.dart';
import 'providers/gave_provider.dart';
import 'utils/calc.dart';
import 'widgets/drawer.dart';
import 'widgets/my_calendar.dart';
import '../products/providers/products_provider.dart';
import '../delivery_boys/providers/delivery_boys_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'providers/day_subscriptions_provider.dart';
import 'widgets/ana_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final productStream = ref.watch(productsProvider);
    final model = ref.watch(calendarViewModelProvider);
    final subscriptionStream =
        ref.watch(daySubscriptionsProvider(model.selectedDate));
    final dboysStream = ref.watch(delilveryBoysProvider);
    final gaveStream = ref.watch(gaveProvider(model.selectedDate));
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: LogoTitle(),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
              );
            },
            icon: CircleAvatar(
              child: Icon(
                Icons.person_outline,
                color: theme.colorScheme.secondary,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          MyCalendar(),
          Expanded(
            child: gaveStream.when(
              data: (gave) => productStream.when(
                data: (products) => subscriptionStream.when(
                  data: (subscriptions) {
                    final calc =
                        Calc(list: subscriptions, date: model.selectedDate);
                    return ListView(
                      padding: const EdgeInsets.all(4),
                      children: <Widget>[
                            Card(
                              child: products.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: MyGrid<Product>(
                                        list: products,
                                        builder: (product) => AnaCard(
                                          product: product,
                                          delivered: calc.delivered(product.id),
                                          estimated: calc.estimated(product.id),
                                          gave: gave.gave(product.id),
                                        ),
                                      ),
                                    )
                                  : ListTile(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const ProductsPage(),
                                          ),
                                        );
                                      },
                                      title: const Text('Add products'),
                                      trailing: const Icon(
                                          Icons.keyboard_arrow_right_rounded),
                                    ),
                            ),
                          ] +
                          (dboysStream.when(
                              data: (dboys) => dboys
                                  .map(
                                    (e) => Card(
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DeliveryBoyHomePage(
                                                      profile: e),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        e.name,
                                                        style: style.subtitle2,
                                                      ),
                                                    ),
                                                    !e.active
                                                        ? Material(
                                                            color: Colors.red,
                                                            shape:
                                                                const StadiumBorder(),
                                                            child: Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 2),
                                                              child: Text(
                                                                Labels.disabled
                                                                    .toUpperCase(),
                                                                style: style
                                                                    .overline!
                                                                    .copyWith(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : const SizedBox()
                                                  ],
                                                ),
                                              ),
                                              MyGrid<Product>(
                                                list: products,
                                                builder: (product) => AnaCard(
                                                  product: product,
                                                  delivered: calc.deliveredByD(
                                                      product.id, e.id),
                                                  estimated: calc.estimatedByD(
                                                      product.id, e.id),
                                                  gave: gave.gaveToD(
                                                      product.id, e.id),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              error: (e, s) => [DataError(e: e)],
                              loading: () => [const Loading()])) +
                          [
                            products.isNotEmpty && subscriptions.isEmpty
                                ? ref.watch(isSubscriptionExistProvider).when(
                                      data: (value) => value
                                          ? const SizedBox()
                                          : Card(
                                              child: ListTile(
                                                title: const Text(
                                                    'Add Customers and their Subscriptions.'),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const CustomersPage(),
                                                    ),
                                                  );
                                                },
                                                trailing: const Icon(Icons
                                                    .keyboard_arrow_right_rounded),
                                              ),
                                            ),
                                      error: (e, s) => const SizedBox(),
                                      loading: () => const SizedBox(),
                                    )
                                : const SizedBox()
                          ],
                    );
                  },
                  error: (e, s) => DataError(e: e),
                  loading: () => const Loading(),
                ),
                error: (e, s) => DataError(e: e),
                loading: () => const Loading(),
              ),
              error: (e, s) => DataError(e: e),
              loading: () => const Loading(),
            ),
          ),
        ],
      ),
    );
  }
}

class MyGrid<T> extends StatelessWidget {
  const MyGrid({Key? key, required this.builder, required this.list})
      : super(key: key);
  final List<T> list;
  final Widget Function(T) builder;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
          int.parse(((list.length / 2) + 0.25).toStringAsFixed(0)), (i) {
        final index = i + 1;
        final item1 = list[(index * 2) - 2];
        final item2 = list.length >= index * 2 ? list[(index * 2) - 1] : null;
        return Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              builder(item1),
              item2 != null ? builder(item2) : const SizedBox()
            ],
          ),
        );
      }),
    );
  }
}
