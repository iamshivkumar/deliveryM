import 'package:delivery_m/core/models/customer.dart';
import 'package:delivery_m/ui/subscriptions/create_subscription_page.dart';
import 'package:delivery_m/ui/subscriptions/widgets/subscription_card.dart';
import 'package:flutter/material.dart';

class CustomerPage extends StatelessWidget {
  const CustomerPage({Key? key, required this.customer}) : super(key: key);

  final Customer customer;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(customer.name),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateSubscriptionPage(
                customer: customer,
              ),
            ),
          );
        },
        label: Text('Subscription'),
        icon: Icon(Icons.add),
      ),
      body: ListView(
        children: <Widget>[
              CustSubscriptionCard(),
              CustSubscriptionCard(),
            ] +
            [
              Card(
                child: Column(
                  children: [
                    ListTile(
                      title: Text('${customer.balance}'),
                      leading: Icon(Icons.account_balance_wallet),
                      trailing: Icon(Icons.add),
                    ),
                  ],
                ),
              ),
              Card(
                child: ListTile(
                  title: Text('+91${customer.mobile}'),
                  leading: Icon(Icons.call),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
              ),
              Card(
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 3 / 2,
                      child: Container(
                        color: Colors.lightGreen.shade100,
                      ),
                    ),
                    ListTile(
                      title: Text('50, Rajendra Nagar, Solapur'),
                      trailing: Icon(Icons.edit),
                    ),
                  ],
                ),
              ),
            ],
      ),
    );
  }
}
