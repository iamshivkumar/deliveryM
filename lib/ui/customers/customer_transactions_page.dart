import 'package:delivery_m/core/models/wallet_transaction.dart';
import 'package:delivery_m/ui/components/loading.dart';
import 'package:delivery_m/ui/doc/doc_viewer_page.dart';
import 'package:delivery_m/utils/formats.dart';
import 'package:delivery_m/utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'providers/customer_transactions_view_model_provider.dart';

class CustomerTransactionsPage extends ConsumerWidget {
  const CustomerTransactionsPage(
      {Key? key, required this.cId, required this.mobile})
      : super(key: key);

  final String cId;
  final String mobile;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final theme = Theme.of(context);
    // final style = theme.textTheme;
    final model = ref.watch(customerTransactionsViewModelProvider(cId));

    return Scaffold(
        appBar: AppBar(
          title: const Text("Wallet Transactions"),
          actions: [
            IconButton(
              onPressed: () {
                model.generate(onDone: (v) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DocViewerPage(
                        file: v,
                        mobile: mobile,
                      ),
                    ),
                  );
                });
              },
              icon: const Icon(Icons.download),
            ),
          ],
        ),
        body: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (!model.busy &&
                notification.metrics.pixels ==
                    notification.metrics.maxScrollExtent) {
              model.loadMore();
            }
            return true;
          },
          child: RefreshIndicator(
            onRefresh: () async =>
                ref.refresh(customerTransactionsViewModelProvider(cId)),
            child: model.initLoading
                ? const Loading()
                : model.transactions.isNotEmpty
                    ? CustomScrollView(
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.all(4),
                            sliver: SliverList(
                              delegate: SliverChildListDelegate(
                                model.transactions
                                    .map(
                                      (e) => TransactionCard(e: e),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Center(
                              child:
                                  model.loading && model.transactions.length > 9
                                      ? const Loading()
                                      : const SizedBox(),
                            ),
                          ),
                        ],
                      )
                    : const Center(
                        child: Text('No Transactions Available'),
                      ),
          ),
        ));
  }
}

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    Key? key,
    required this.e,
  }) : super(key: key);

  final WalletTransaction e;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        "${Labels.rupee} ${e.amount}",
                        style: style.subtitle1!.copyWith(
                            color: e.amount.isNegative
                                ? Colors.red
                                : Colors.green),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        "${Labels.rupee} ${e.balance}",
                        style: style.subtitle1,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        Formats.monthDayTime(e.createdAt),
                        style: style.caption,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            e.isDeliveryTransaction
                ? Padding(
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              e.name!,
                              style: style.caption!
                                  .copyWith(color: style.bodyText1!.color),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              Formats.monthDayFromDate(e.date!),
                              style: style.subtitle2,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              '${e.quantity}',
                              style: style.subtitle1!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: e.quantity!.isNegative
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
