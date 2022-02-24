import 'package:delivery_m/ui/customers/providers/customer_subscriptions_provider.dart';
import 'package:delivery_m/ui/subscriptions/subscription_page.dart';
import 'package:delivery_m/ui/subscriptions/widgets/subscription_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomerSubscriptionsPage extends ConsumerWidget {
  const CustomerSubscriptionsPage({
    Key? key,
    required this.cId,
    required this.name,
  }) : super(key: key);

  final String name;
  final String cId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionsStream = ref.watch(customerSubscriptionsProvider(cId));
    final inactiveSubscriptionsStream =
        ref.watch(customerInactiveSubscriptionsProvider(cId));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscriptions'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(4),
        children: <Widget>[] +
            subscriptionsStream.when(
              data: (subscriptions) => subscriptions
                  .map(
                    (e) => CustSubscriptionCard(subscription: e),
                  )
                  .toList(),
              error: (e, s) => [],
              loading: () => [],
            ) +
            inactiveSubscriptionsStream.when(
              data: (subscriptions) => subscriptions
                  .map(
                    (e) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SubscriptionPageRoot(sId: e.id),
                          ),
                        );
                      },
                      child: CustSubscriptionCard(subscription: e,enabled: false,),
                    ),
                  )
                  .toList(),
              error: (e, s) => [],
              loading: () => [],
            ),
      ),
    );
  }
}
