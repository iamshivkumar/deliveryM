import '../../core/repositories/subscription_repository_provider.dart';
import '../customers/providers/customer_subscriptions_provider.dart';
import 'providers/add_delivery_view_model_provider.dart';
import 'widgets/add_delivery_sheet.dart';
import 'widgets/subscription_card.dart';
import '../../utils/formats.dart';
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
    // final style = theme.textTheme;

    final repository = ref.read(subscriptionRepositoryProvider);

    final subscription = ref
        .watch(customerSubscriptionsProvider(cId))
        .value!
        .where((element) => element.id == sId)
        .first;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription Details'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => AddDeliverySheet(subscription: subscription),
          );
          ref.read(addDeliveryViewModelProvider).clear();
        },
        label: const Text('Add Delivery Day'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 64),
        children: <Widget>[
              CustSubscriptionCard(
                subscription: subscription,
                enabled: false,
              ),
            ] +
            (subscription.deliveries
                .map(
                  (e) => Dismissible(
                    key: ValueKey(e.date),
                    direction: e.dateTime.isAfter(DateTime.now())
                        ? DismissDirection.startToEnd
                        : DismissDirection.none,
                    background: Material(
                      color: theme.errorColor,
                      child: Row(
                        children: const [
                          AspectRatio(
                            aspectRatio: 1,
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                    onDismissed: (v) {
                      repository.deleteDelivery(sId: sId, delivery: e);
                    },
                    confirmDismiss: (v) async {
                      return await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text(
                            "Are you sure you want to delete this delivery day?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('NO'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              child: const Text('YES'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(Formats.monthDayFromDate(e.date)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('${e.quantity}'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Material(
                                shape: const StadiumBorder(),
                                color: theme.dividerColor,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  child: Text(e.status),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                .toList()),
      ),
    );
  }
}
