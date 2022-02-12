import 'package:delivery_m/core/models/subscription.dart';
import 'package:delivery_m/ui/colors.dart';
import 'package:delivery_m/ui/components/error.dart';
import 'package:delivery_m/ui/components/loading.dart';
import 'package:delivery_m/ui/customers/providers/customer_provider.dart';
import 'package:delivery_m/ui/delivery_boys/delivery_boys_page.dart';
import 'package:delivery_m/ui/delivery_boys/providers/delivery_boys_provider.dart';
import 'package:delivery_m/ui/doc/doc_viewer_page.dart';
import 'package:delivery_m/ui/pdf/providers/generate_pdf_view_model_provider.dart';
import 'package:delivery_m/ui/subscriptions/providers/subscription_provider.dart';

import '../../core/repositories/subscription_repository_provider.dart';
import '../customers/providers/customer_subscriptions_provider.dart';
import 'providers/add_delivery_view_model_provider.dart';
import 'widgets/add_delivery_sheet.dart';
import 'widgets/subscription_card.dart';
import '../../utils/formats.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SubscriptionPage extends ConsumerWidget {
  const SubscriptionPage({Key? key, required this.subscription})
      : super(key: key);
  final Subscription subscription;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;

    final repository = ref.read(subscriptionRepositoryProvider);
    ref.read(customerProvider(subscription.customerId));
    final _dboys = ref.watch(delilveryBoysProvider).value!;
    final filetered = _dboys.where((e) => e.id == subscription.dId);
    final dboy = filetered.isNotEmpty ? filetered.first : null;
    final generator = ref.read(generatePdfViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription Details'),
        actions: [
          IconButton(
            onPressed: () {
              generator.generate(
                onDone: (v) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DocViewerPage(file: v),
                    ),
                  );
                },
                subscription: subscription,
                customer:
                    ref.read(customerProvider(subscription.customerId)).value!,
              );
            },
            icon: const Icon(Icons.download),
          ),
        ],
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
              dboy != null
                  ? Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Delivery boy',
                              style: style.bodyText1,
                            ),
                            const SizedBox(height: 8),
                            Text(dboy.name),
                            const SizedBox(height: 4),
                            Text(
                              dboy.address.formated,
                              style: style.caption,
                            ),
                            const SizedBox(height: 8),
                            OutlinedButton(
                              onPressed: () async {
                                final String? id = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    fullscreenDialog: true,
                                    builder: (context) =>
                                        const DeliveryBoysPage(forSelect: true),
                                  ),
                                );
                                if (id != null) {
                                  if (id == subscription.dId) {
                                    return;
                                  }
                                  final filetered =
                                      _dboys.where((e) => e.id == id);
                                  final newDboy = filetered.isNotEmpty
                                      ? filetered.first
                                      : null;
                                  if (newDboy != null) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: RichText(
                                          text: TextSpan(
                                            text:
                                                'Are you sure you want assign this subscrption to ',
                                            style: style.subtitle1,
                                            children: [
                                              TextSpan(
                                                text: "${newDboy.name} ",
                                                style:
                                                    style.subtitle1!.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const TextSpan(
                                                text: "for delivery?",
                                              )
                                            ],
                                          ),
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
                                              repository.changeDboy(
                                                  sId: subscription.id,
                                                  dId: id);
                                              Navigator.pop(context);
                                            },
                                            child: const Text('YES'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                }
                              },
                              child: const Text('CHANGE'),
                            )
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(),
              // Card(
              //   child: ListTile(
              //     onTap: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => WalletTransactionsPage(
              //             name: subscription.productName,
              //             sId: subscription.id,
              //           ),
              //         ),
              //       );
              //     },
              //     title: const Text('Wallet Transactions'),
              //     trailing: const Icon(Icons.keyboard_arrow_right),
              //   ),
              // )
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
                      repository.deleteDelivery(
                          sId: subscription.id, delivery: e);
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
                                color: AppColors.statusColor(e.status),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  child: Text(
                                    e.status.toUpperCase(),
                                    style: style.caption!.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
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

class SubscriptionPageFromCustomer extends ConsumerWidget {
  const SubscriptionPageFromCustomer(
      {Key? key, required this.cId, required this.sId})
      : super(key: key);
  final String cId;
  final String sId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscription = ref
        .watch(customerSubscriptionsProvider(cId))
        .value!
        .where((element) => element.id == sId)
        .first;
    return SubscriptionPage(subscription: subscription);
  }
}

class SubscriptionPageRoot extends ConsumerWidget {
  const SubscriptionPageRoot({Key? key, required this.sId}) : super(key: key);

  final String sId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(subscriptionProvider(sId)).when(
          data: (subscription) => SubscriptionPage(subscription: subscription),
          error: (e, s) => DataErrorPage(e: e),
          loading: () => const LoadingPage(),
        );
  }
}
