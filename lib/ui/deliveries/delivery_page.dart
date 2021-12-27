import 'package:flutter/material.dart';

import 'widgets/delivery_product_widget.dart';

class DeliveryPage extends StatelessWidget {
  const DeliveryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Name'),
      ),
      body: ListView(
        children: [
          Card(
            child: Column(
              children: [
                DeliveryProductWidget(),
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
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
