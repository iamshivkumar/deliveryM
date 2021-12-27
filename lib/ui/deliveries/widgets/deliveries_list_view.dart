import 'package:flutter/material.dart';

import 'delivery_card.dart';


class DeliveriesListView extends StatelessWidget {
  const DeliveriesListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        ListView(
          children:[1,2,3,4,5,6,7].map((e) =>DeliveryCard() ).toList(),
        ),
        ListView(),
        ListView(),
      ],
    );
  }
}