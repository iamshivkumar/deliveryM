import 'package:flutter/material.dart';


class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return ListTile(
      leading: CircleAvatar(),
      title: Text('Product Name'),
      trailing: Text(
        '\$100',
        style: style.headline6,
      ),
    );
  }
}
