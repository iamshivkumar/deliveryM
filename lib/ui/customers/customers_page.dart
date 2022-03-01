import '../components/error.dart';
import '../components/loading.dart';
import '../components/search_feild.dart';
import 'providers/customers_provider.dart';
import 'providers/write_customer_view_model.dart';
import 'widgets/customer_card.dart';
import 'write_customer_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final searchKeyProvider = StateProvider<String>((ref) => '');

class CustomersPage extends ConsumerWidget {
  const CustomersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final customersStream = ref.watch(customersProvider);
    final searchKey = ref.watch(searchKeyProvider.state);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WriteCustomerPage(),
            ),
          );
          ref.read(writeCustomerViewModelProvider).clear();
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.zero,
            shape: const ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SearchField(
                onChanged: (v) => searchKey.state = v,
              ),
            ),
          ),
          Expanded(
            child: customersStream.when(
              data: (customers) {
                customers.sort((a, b) => a.name.compareTo(b.name));
                return ListView(
                padding: const EdgeInsets.all(4),
                children: customers
                    .where(
                      (element) => element.searchKey.contains(
                        searchKey.state.toLowerCase(),
                      ),
                    )
                    .map((e) => CustomerCard(customer: e))
                    .toList(),
              );
              },
              error: (e, s) => DataError(e: e),
              loading: () => const Loading(),
            ),
          ),
        ],
      ),
    );
  }
}
