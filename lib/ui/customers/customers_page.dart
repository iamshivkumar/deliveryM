import 'package:delivery_m/ui/components/error.dart';
import 'package:delivery_m/ui/components/loading.dart';
import 'package:delivery_m/ui/customers/providers/customers_provider.dart';
import 'package:delivery_m/ui/customers/providers/write_customer_view_model.dart';
import 'package:delivery_m/ui/customers/widgets/customer_card.dart';
import 'package:delivery_m/ui/customers/write_customer_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomersPage extends ConsumerWidget {
  const CustomersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customersStream = ref.watch(customersProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Customers'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async  {
         await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WriteCustomerPage(),
            ),
          );
          ref.read(writeCustomerViewModelProvider).clear();
        },
        child: Icon(Icons.add),
      ),
      body: customersStream.when(
        data: (customers) => ListView(
          children: customers.map((e) => CustomerCard(customer: e)).toList(),
        ),
        error: (e, s) => DataError(e: e),
        loading: () => const Loading(),
      ),
    );
  }
}
