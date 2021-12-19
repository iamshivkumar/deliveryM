
import 'package:delivery_m/ui/customers/widgets/customer_card.dart';
import 'package:delivery_m/ui/customers/write_customer_page.dart';
import 'package:flutter/material.dart';

class CustomersPage extends StatelessWidget {
  const CustomersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customers'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WriteCustomerPage(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      body: ListView(
        children: [
          CustomerCard(),
        ],
      ),
    );
  }
}
