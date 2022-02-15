import 'package:delivery_m/ui/components/error.dart';
import 'package:delivery_m/ui/components/loading.dart';
import 'package:delivery_m/ui/customers/providers/customer_provider.dart';
import 'package:delivery_m/utils/labels.dart';

import '../../../core/enums/delivery_status.dart';
import '../../../core/models/subscription.dart';
import '../subscription_page.dart';
import '../../../utils/formats.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SubscriptionCard extends ConsumerWidget {
  const SubscriptionCard({Key? key, required this.subscription})
      : super(key: key);
  final Subscription subscription;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;

    final customerStream = ref.watch(customerProvider(subscription.customerId));
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubscriptionPageRoot(sId: subscription.id),
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Formats.monthDay(subscription.startDate),
                      style: style.caption,
                    ),
                    Text(
                      'TO',
                      style: style.overline,
                    ),
                    Text(
                      Formats.monthDay(subscription.endDate),
                      style: style.caption,
                    ),
                  ],
                ),
              ),
              customerStream.when(
                data: (customer) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          customer.name,
                          style: style.bodyText1,
                        ),
                      ),
                      Text("${customer.address.area}, ${customer.address.city}")
                    ],
                  ),
                ),
                error: (e, s) => DataError(e: e),
                loading: () => const Loading(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(subscription.product.name),
                    ),
                    Text(
                      '${Labels.rupee}${subscription.product.price}',
                      style: style.subtitle2,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      flex: subscription.deliveries
                          .where((element) =>
                              element.status == DeliveryStatus.delivered)
                          .length,
                      child: Container(
                        height: 4,
                        color: Colors.green,
                      ),
                    ),
                    Expanded(
                      flex: subscription.deliveries
                          .where((element) =>
                              element.status == DeliveryStatus.pending)
                          .length,
                      child: Container(
                        height: 4,
                        color: theme.dividerColor,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustSubscriptionCard extends ConsumerWidget {
  const CustSubscriptionCard({
    Key? key,
    this.enabled = true,
    required this.subscription,
  }) : super(key: key);

  final Subscription subscription;
  final bool enabled;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;

    return GestureDetector(
      onTap: enabled
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubscriptionPageFromCustomer(
                    cId: subscription.customerId,
                    sId: subscription.id,
                  ),
                ),
              );
            }
          : null,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Formats.monthDay(subscription.startDate),
                      style: style.caption,
                    ),
                    Text(
                      'TO',
                      style: style.overline,
                    ),
                    Text(
                      Formats.monthDay(subscription.endDate),
                      style: style.caption,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child:
                          Text(subscription.product.name),
                    ),
                    Text(
                      '${Labels.rupee}${subscription.product.price}',
                      style: style.subtitle2,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      flex: subscription.deliveries
                          .where((element) =>
                              element.status == DeliveryStatus.delivered)
                          .length,
                      child: Container(
                        height: 4,
                        color: Colors.green,
                      ),
                    ),
                    Expanded(
                      flex: subscription.deliveries
                          .where((element) =>
                              element.status == DeliveryStatus.pending)
                          .length,
                      child: Container(
                        height: 4,
                        color: theme.dividerColor,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
