import 'package:delivery_m/core/models/dboy_day.dart';
import 'package:delivery_m/ui/profile/profile_page.dart';
import 'package:delivery_m/ui/profile/providers/profile_provider.dart';
import 'package:flutter/foundation.dart';

import '../../core/models/profile.dart';
import '../../core/repositories/gave_repository_provider.dart';
import '../components/error.dart';
import '../components/loading.dart';
import '../components/logo_title.dart';
import '../deliveries/deliveries_page.dart';
import 'providers/calendar_view_model_provider.dart';
import 'providers/dboy_day_subscriptions_provider.dart';
import 'widgets/give_sheet.dart';
import 'widgets/my_calendar.dart';
import '../products/providers/products_provider.dart';
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
    // final style = theme.textTheme;
    final model = ref.watch(calendarViewModelProvider);
    final dboyDay = DboyDay(dId: profile.id, date: model.selectedDate);
    final gaveStream = ref.watch(gaveProvider(model.selectedDate));
    final myProfile = ref.read(profileProvider).value!;
    final productsStream = ref.watch(productsProvider);
    final subscriptionStream = ref.watch(dboyDaySubscriptionsProvider(dboyDay));
    final _repository = ref.read(gaveRepositoryProvider);
    return Scaffold(
      appBar: AppBar(
        // elevation: 0,
        centerTitle: true,
        title: myProfile.isAdmin ? Text(profile.name) : const LogoTitle(),
        shadowColor: theme.primaryColor.withOpacity(0.4),
        actions: [
          !myProfile.isAdmin
              ? IconButton(
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
                )
              : const SizedBox(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DeliveriesPage(dboyDay: dboyDay),
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
            forceElevated: true,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: MyCalendar(),
            ),
            shape: const ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
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
                              onTap: myProfile.isAdmin
                                  ? () async {
                                      final int? quantity =
                                          await showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        shape: ContinuousRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(32),
                                        ),
                                        builder: (context) => GiveSheet(
                                            initial:
                                                gave.gaveToD(e.id, profile.id),
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
                                          if (kDebugMode) {
                                            print('$e');
                                          }
                                        }
                                      }
                                    }
                                  : null,
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
