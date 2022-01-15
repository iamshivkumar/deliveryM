import 'package:delivery_m/core/models/product.dart';
import 'package:delivery_m/ui/components/error.dart';
import 'package:delivery_m/ui/components/loading.dart';
import 'package:delivery_m/ui/products/providers/products_provider.dart';
import 'package:delivery_m/ui/products/providers/write_product_view_model_provider.dart';
import 'package:delivery_m/ui/products/widgets/write_product_sheet.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'widgets/product_card.dart';

class ProductsPage extends ConsumerWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final writer = ref.read(writeProductViewModelProvider);
    final productStream = ref.watch(productsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => const WriteProductSheet(),
          );
          writer.clear();
        },
        child: Icon(Icons.add),
      ),
      body: productStream.when(
        data: (products) => ListView(
          children: products
              .map(
                (e) => ProductCard(product: e),
              )
              .toList(),
        ),
        error: (e, s) => DataError(e: e),
        loading: () => Loading(),
      ),
    );
  }
}
