import 'package:delivery_m/ui/subscriptions/widgets/subscription_card.dart';
import 'package:flutter/material.dart';

class CustomerPage extends StatelessWidget {
  const CustomerPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Name'),
      ),
      body: ListView(
        children: <Widget>[
          CustSubscriptionCard(),
          CustSubscriptionCard(),
        ]+[
          Card(
            child: Column(
              children: [
                ListTile(
                  title: Text('25'),
                  leading: Icon(Icons.account_balance_wallet),
                  trailing: Icon(Icons.add),
                ),
             
              ],
            ),
          ),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: Text('+919284103047'),
                  leading: Icon(Icons.call),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
                Divider(height: 0.5),
                ListTile(
                  title: Text('shivkonade123@gmail.com'),
                  leading: Icon(Icons.email),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
              ],
            ),
          ),
           Card(
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 3/2,
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