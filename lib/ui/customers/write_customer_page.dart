import 'package:delivery_m/ui/pick_address/pick_address_page.dart';
import 'package:delivery_m/utils/labels.dart';
import 'package:flutter/material.dart';

class WriteCustomerPage extends StatelessWidget {
  const WriteCustomerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Customer'),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: MaterialButton(
          minWidth: double.infinity,
          color: scheme.secondary,
          onPressed: () {},
          child: Text('ADD'),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(24),
        children: [
          Row(
            children: [
              Container(
                height: 100,
                width: 100,
                color: theme.primaryColorLight,
              ),
            ],
          ),
          SizedBox(height: 16),
          TextFormField(
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Mobile Number',
              prefixText: '+91 ',
            ),
          ),
          SizedBox(height: 16),
          Card(
            margin: EdgeInsets.zero,
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PickAddressPage(),
                  ),
                );
              },
              leading: Icon(Icons.location_pin),
              title: Text('Pick Location'),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
          ),
          SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {},
            child: Text('ADD DOCUMENT'),
          ),
        ],
      ),
    );
  }
}
