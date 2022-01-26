import 'package:delivery_m/ui/customers/providers/customer_subscriptions_provider.dart';
import 'package:delivery_m/ui/subscriptions/widgets/subscription_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SubscriptionPage extends ConsumerWidget {
  const SubscriptionPage({Key? key, required this.cId, required this.sId})
      : super(key: key);
  final String cId;
  final String sId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;

    final subscription = ref
        .watch(customerSubscriptionsProvider(cId))
        .value!
        .where((element) => element.id == sId)
        .first;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription Details'),
      ),
      body: ListView(
        children: <Widget>[CustSubscriptionCard(subscription: subscription)] +
            (subscription.deliveries
                .map(
                  (e) => Card(
                    child: ListTile(
                      title: Text(e.date),
                      subtitle: Text(e.status),
                      trailing: Text(
                        "${e.quantity}",
                        style: style.headline6,
                      ),
                    ),
                  ),
                )
                .toList()),
      ),
    );
  }
}
