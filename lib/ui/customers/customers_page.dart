import '../components/error.dart';
import '../components/loading.dart';
import 'providers/customers_provider.dart';
import 'providers/write_customer_view_model.dart';
import 'widgets/customer_card.dart';
import 'write_customer_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomersPage extends ConsumerWidget {
  const CustomersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customersStream = ref.watch(customersProvider);
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
      body: customersStream.when(
        data: (customers) => ListView(
          padding: const EdgeInsets.all(4),
          children: customers.map((e) => CustomerCard(customer: e)).toList(),
        ),
        error: (e, s) => DataError(e: e),
        loading: () => const Loading(),
      ),
    );
  }
}
