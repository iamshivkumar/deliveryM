import '../../../core/models/product.dart';
import 'package:flutter/material.dart';

class BigAnaCard extends StatelessWidget {
  const BigAnaCard({
    Key? key,
    required this.product,
    required this.delivered,
    required this.estimated,
    required this.pending,
    required this.onTap,
    required this.gave,
  }) : super(key: key);

  final Product product;
  final int delivered;
  final int estimated;
  final int pending;
  final int gave;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final onTheWay = gave - delivered;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: SizedBox(
                          height: 28,
                          width: 28,
                          child: Image.asset(product.image),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          product.name,
                          style: style.subtitle2,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                onTap != null
                    ? IconButton(
                        onPressed: onTap,
                        icon: const Icon(Icons.add),
                      )
                    : const SizedBox(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delivered',
                          style: style.caption!.copyWith(
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          '$delivered',
                          style: const TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gave',
                          style: style.caption!.copyWith(
                            color: Colors.orange,
                          ),
                        ),
                        Text(
                          '$gave',
                          style: const TextStyle(color: Colors.orange),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Estimated',
                          style: style.caption!.copyWith(
                            color: Colors.blue,
                          ),
                        ),
                        Text(
                          '$estimated',
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pending',
                          style: style.caption,
                        ),
                        Text('$pending'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'On the way',
                          style: style.caption,
                        ),
                        Text('$onTheWay'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Should give',
                          style: style.caption,
                        ),
                        Text('${pending - onTheWay}'),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
