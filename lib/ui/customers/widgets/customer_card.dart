import 'package:delivery_m/ui/customers/customer_page.dart';
import 'package:flutter/material.dart';

class CustomerCard extends StatelessWidget {
  const CustomerCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CustomerPage(),
          ),
        );
      },
      leading: CircleAvatar(),
      title: Text('Customer Name'),
      subtitle: Text('A50, Saiful, Solapur'),
    );
  }
}
