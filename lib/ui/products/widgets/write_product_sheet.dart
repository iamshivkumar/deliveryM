import 'package:flutter/material.dart';

class WriteProductSheet extends StatelessWidget {
  const WriteProductSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Add Product',
            style: style.headline6,
          ),
          SizedBox(height: 16),
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
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Price'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            child: Text('ADD'),
          )
        ],
      ),
    );
  }
}
