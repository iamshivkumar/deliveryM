import 'package:delivery_m/ui/products/widgets/write_product_sheet.dart';
import 'package:flutter/material.dart';

import 'widgets/product_card.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => WriteProductSheet(),
          );
        },
        child: Icon(Icons.add),
      ),
      body: ListView(
        children: [
          ProductCard(),
        ],
      ),
    );
  }
}
