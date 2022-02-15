import 'package:delivery_m/core/models/dboy_day.dart';
import 'package:delivery_m/utils/labels.dart';

import '../../../core/enums/delivery_status.dart';
import '../../../core/models/subscription.dart';
import '../../../core/repositories/subscription_repository_provider.dart';
import 'add_returned_kits_quantity_sheet.dart';
import 'deliver_sheet.dart';
import '../../home/providers/dboy_day_subscriptions_provider.dart';
import '../../../utils/formats.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DeliveryProductWidget extends ConsumerWidget {
  const DeliveryProductWidget({
    Key? key,
    required this.subscription,
    required this.date,
  }) : super(key: key);

  final Subscription subscription;
  final DateTime date;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final updated = ref
        .watch(dboyDaySubscriptionsProvider(
            DboyDay(dId: subscription.dId, date: date)))
        .value!
        .where((element) => element.id == subscription.id)
        .first;

 
    final delivery = updated.getDelivery(date);
    final repository = ref.read(subscriptionRepositoryProvider);
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(
                height: 32,
                width: 32,
                child:
                    Image.network(subscription.product.image),
              ),
            ),
            title: Row(
              children: [
                Flexible(
                    child: Text(subscription.product.name)),
                const SizedBox(width: 8),
                Material(
                  color: theme.dividerColor,
                  shape: const StadiumBorder(),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    child: Text(
                      delivery.status,
                      style: style.overline,
                    ),
                  ),
                ),
              ],
            ),
            subtitle: Text('${Labels.rupee}${updated.product.price}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${delivery.quantity}",
                  style: style.headline6,
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () async {
                    final int? quantity = await showModalBottomSheet(
                      context: context,
                      builder: (context) => DeliverSheet(
                        initial: delivery.quantity,
                        name: subscription.product.name,
                        image: subscription.product.image,
                      ),
                    );
                    if (quantity != null) {
                      repository.update(
                        subscription: updated,
                        updated: delivery.copyWith(
                          quantity: delivery.quantity + quantity,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Formats.monthDay(updated.startDate),
                  style: style.caption,
                ),
                Text(
                  'TO',
                  style: style.overline,
                ),
                Text(
                  Formats.monthDay(updated.endDate),
                  style: style.caption,
                ),
              ],
            ),
          ),
          updated.returnKitsQt != null
              ? Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 8, 16),
                      child: Row(
                        children: [
                          Text(
                            'Return Kits: ',
                            style: style.caption,
                          ),
                          Text(
                            "${updated.returnKitsQt}",
                            style: style.subtitle2,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final int? quantity = await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => AddReturnedKitsQuantitySheet(
                              available: updated.returnKitsQt!),
                        );
                        if (quantity != null) {
                          repository.returnKitsQuantity(
                              sId: updated.id, qt: quantity);
                        }
                      },
                      icon: const Icon(Icons.edit),
                    )
                  ],
                )
              : const SizedBox(),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
            child: Row(
              children: [
                delivery.status != DeliveryStatus.delivered
                    ? Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: OutlinedButton(
                            onPressed: () async {
                              final bool? value = await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text(
                                    'Are you sure you want to mark as delivered?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("NO"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                      child: const Text("YES"),
                                    )
                                  ],
                                ),
                              );
                              if (value ?? false) {
                                repository.update(
                                  subscription: updated,
                                  updated: delivery.copyWith(
                                    status: DeliveryStatus.delivered,
                                  ),
                                );
                              }
                            },
                            child: const Text('Mark as Delivered'),
                          ),
                        ),
                      )
                    : const SizedBox(),
                delivery.status != DeliveryStatus.canceled
                    ? Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: OutlinedButton(
                            onPressed: () async {
                              final bool? value = await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text(
                                    'Are you sure you want to mark as canceled?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("NO"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                      child: const Text("YES"),
                                    )
                                  ],
                                ),
                              );
                              if (value ?? false) {
                                repository.update(
                                  subscription: updated,
                                  updated: delivery.copyWith(
                                    status: DeliveryStatus.canceled,
                                  ),
                                );
                              }
                            },
                            child: const Text('Mark as Canceled'),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
