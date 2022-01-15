import 'package:delivery_m/core/models/customer.dart';
import 'package:delivery_m/ui/customers/customer_page.dart';
import 'package:flutter/material.dart';

class CustomerCard extends StatelessWidget {
  const CustomerCard({Key? key, required this.customer}) : super(key: key);
  final Customer customer;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CustomerPage(customer: customer),
          ),
        );
      },
      title: Text(customer.name),
      subtitle: Text(customer.address.formated),
    );
  }
}
