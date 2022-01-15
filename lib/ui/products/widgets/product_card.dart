import 'package:delivery_m/core/repositories/products_repository_provider.dart';
import 'package:delivery_m/ui/products/providers/write_product_view_model_provider.dart';
import 'package:delivery_m/utils/labels.dart';
import 'package:flutter/material.dart';

import 'package:delivery_m/core/models/product.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'write_product_sheet.dart';

class ProductCard extends ConsumerWidget {
  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);
  final Product product;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Dismissible(
      key: ValueKey(product.id),
      onDismissed: (v) =>
          ref.read(productsRepositoryProvider).delete(product.id),
      confirmDismiss: (v) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure you want to delete this product?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('NO'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text('YES'),
              ),
            ],
          ),
        );
      },
      direction: DismissDirection.startToEnd,
      background: Material(
        color: theme.errorColor,
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
      child: Card(
        child: ListTile(
          leading: Padding(
            padding: const EdgeInsets.all(4),
            child: Image.network(product.image),
          ),
          title: Text(product.name),
          subtitle: Text(
            '${Labels.rupee}${product.price}',
          ),
          trailing: IconButton(
              onPressed: () async {
                final writer = ref.read(writeProductViewModelProvider);
                writer.initial = product;
                await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => const WriteProductSheet(),
                );
                writer.clear();
              },
              icon: const Icon(Icons.edit)),
        ),
      ),
    );
  }
}
