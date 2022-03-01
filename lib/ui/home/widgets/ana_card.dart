import '../../../core/models/product.dart';
import 'package:flutter/material.dart';

class AnaCard extends StatelessWidget {
  const AnaCard({
    Key? key,
    required this.product,
    required this.delivered,
    required this.estimated,
    required this.gave,
  }) : super(key: key);
  final Product product;
  final int delivered;
  final int estimated;
  final int gave;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            SizedBox(
              height: 28,
              width: 28,
              child: Image.asset(product.image),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.name,
                    style: style.caption,
                  ),
                  const SizedBox(width: 8),
                  Wrap(
                    children: [
                      Text(
                        '$delivered',
                        style: const TextStyle(color: Colors.green),
                      ),
                      const Text('/'),
                      Text(
                        '$gave',
                        style: const TextStyle(color: Colors.orange),
                      ),
                      const Text(
                        '/',
                      ),
                      Text(
                        '$estimated',
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
