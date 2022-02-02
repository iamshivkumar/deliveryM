import 'package:delivery_m/ui/customers/customer_transactions_page.dart';
import 'package:delivery_m/ui/pick_address/widgets/picked_address_card.dart';

import '../../core/repositories/customers_repository_provider.dart';
import '../components/error.dart';
import '../components/loading.dart';
import 'providers/customer_subscriptions_provider.dart';
import 'providers/customers_provider.dart';
import 'widgets/add_balance_sheet.dart';
import '../subscriptions/create_subscription_page.dart';
import '../subscriptions/widgets/subscription_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomerPage extends ConsumerWidget {
  const CustomerPage({Key? key, required this.cId}) : super(key: key);

  final String cId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionsStream = ref.watch(customerSubscriptionsProvider(cId));
    final customer =
        ref.watch(customersProvider).value!.where((e) => e.id == cId).first;
    final repository = ref.read(customersRepositoryProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(customer.name),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateSubscriptionPage(
                customer: customer,
              ),
            ),
          );
        },
        label: const Text('Subscription'),
        icon: const Icon(Icons.add),
      ),
      body: ListView(
        children: <Widget>[] +
            subscriptionsStream.when(
              data: (subscriptions) => subscriptions
                  .map(
                    (e) => CustSubscriptionCard(
                      subscription: e,
                    ),
                  )
                  .toList(),
              error: (e, s) => [DataError(e: e)],
              loading: () => [
                const Loading(),
              ],
            ) +
            [
              Card(
                child: Column(
                  children: [
                    ListTile(
                      title: Text('${customer.balance}'),
                      leading: const Icon(Icons.account_balance_wallet),
                      trailing: IconButton(
                        onPressed: () async {
                          final double? amount = await showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => const AddBalanceSheet(),
                          );
                          if (amount != null) {
                            repository.addBalance(cId: cId, amount: amount);
                          }
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ),
                    ListTile(
                      title: const Text('Transactions'),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustomerTransactionsPage(
                              cId: customer.id,
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
              Card(
                child: ListTile(
                  title: Text('+91${customer.mobile}'),
                  leading: const Icon(Icons.call),
                  trailing: const Icon(Icons.keyboard_arrow_right),
                  onTap: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: PickedAddressCard(
                  address: customer.address,
                  onChanged: (v) {
                    repository.updateAddress(cId: cId, address: v);
                  },
                ),
              ),
            ],
      ),
    );
  }
}
