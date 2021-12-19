
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
          TextFormField(
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              labelText: Labels.houseFlatBlockNo,
            ),
          ),
          SizedBox(height: 16),
          TextFormField(
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: 'Area',
            ),
          ),
          SizedBox(height: 16),
          TextFormField(
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: Labels.cityVillage,
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
