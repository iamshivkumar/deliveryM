import '../../../core/models/customer.dart';
import '../customer_page.dart';
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
            builder: (context) => CustomerPage(cId: customer.id),
          ),
        );
      },
      title: Text(customer.name),
      subtitle: Text(customer.address.formated),
    );
  }
}
