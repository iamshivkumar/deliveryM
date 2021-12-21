import 'package:flutter/material.dart';

class DeliveryCard extends StatelessWidget {
  const DeliveryCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(),
          title: Text('Customer Name'),
          subtitle: Text('A50, Saiful, Solapur'),
        ),
        GridView.count(
          crossAxisCount: 2,
          children: [

          ],
        ),
      ],
    );
  }
}
