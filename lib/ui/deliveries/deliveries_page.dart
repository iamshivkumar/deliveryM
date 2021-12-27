import 'package:delivery_m/ui/customers/widgets/customer_card.dart';
import 'package:delivery_m/ui/deliveries/widgets/delivery_card.dart';
import 'package:flutter/material.dart';

import 'widgets/deliveries_list_view.dart';

class DeliveriesPage extends StatelessWidget {
  const DeliveriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Deliveries'),
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Pending',
              ),
              Tab(
                text: 'Delivered',
              ),
              Tab(
                text: 'Cancelled',
              ),
            ],
          ),
        ),
        body: Container(
          color: Colors.lightGreen.shade100,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DeliveryCard(),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
