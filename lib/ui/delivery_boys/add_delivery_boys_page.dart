import 'package:flutter/material.dart';

class AddDeliveryBoysPage extends StatelessWidget {
  const AddDeliveryBoysPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add delivery boy mobile number'),
      ),
      body: Column(
        children: [
          Material(
            elevation: 2,
            color: theme.cardColor,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(prefixText: '+91 '),
                    ),
                  ),
                  SizedBox(width: 16),
                  SizedBox(
                    height: 48,
                    width: 48,
                    child: MaterialButton(
                      padding: EdgeInsets.zero,
                      minWidth: 0,
                      shape: CircleBorder(),
                      color: scheme.secondary,
                      onPressed: () {},
                      child: Icon(Icons.add),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(4),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                  child: Text('Pending Sign Ups'),
                ),
                Card(
                  child: ListTile(
                    title: Text('+91 9284103047'),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
