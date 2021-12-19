import 'package:delivery_m/ui/subscriptions/create_subscription_page.dart';
import 'package:flutter/material.dart';

import 'widgets/subscription_card.dart';

class SubscriptionsPage extends StatelessWidget {
  const SubscriptionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscriptions'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateSubscriptionPage(),
            ),
          );
        },
      ),
      body: ListView(
        padding: EdgeInsets.all(4),
        children: [
          SubscriptionCard(),
        ],
      ),
    );
  }
}
