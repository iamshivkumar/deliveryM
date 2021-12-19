import 'package:flutter/material.dart';

class CustomerCard extends StatelessWidget {
  const CustomerCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(),
      title: Text('Customer Name'),
      subtitle: Text('A50, Saiful, Solapur'),
    );
  }
}
