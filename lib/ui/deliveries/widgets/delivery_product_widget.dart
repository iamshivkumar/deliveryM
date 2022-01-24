import 'package:delivery_m/core/models/subscription.dart';
import 'package:delivery_m/ui/deliveries/widgets/deliver_sheet.dart';
import 'package:delivery_m/ui/products/providers/products_provider.dart';
import 'package:delivery_m/utils/formats.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DeliveryProductWidget extends ConsumerWidget {
  const DeliveryProductWidget({
    Key? key,
    required this.subscription,
    required this.date,
  }) : super(key: key);

  final Subscription subscription;
  final DateTime date;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final products = ref.watch(productsProvider).value!;
    final filtered =
        products.where((element) => element.id == subscription.productId);
    final product = filtered.isNotEmpty ? filtered.first : null;
    final delivery = subscription.getDelivery(date);
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(
                height: 32,
                width: 32,
                child: product != null
                    ? Image.network(product.image)
                    : const Icon(Icons.info_outline),
              ),
            ),
            title: Row(
              children: [
                Flexible(child: Text(product?.name ?? "unknown")),
                const SizedBox(width: 8),
                Material(
                  color: theme.dividerColor,
                  shape: const StadiumBorder(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6,vertical: 2),
                    child: Text(delivery.status,style: style.overline,),
                  ),
                ),
              ],
            ),
            subtitle: Text('\$${subscription.price}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${delivery.quantity}",
                  style: style.headline6,
                ),
                SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(context: context, builder: (context)=>DeliverSheet(initial: delivery.quantity, product: product));
                  },
                  icon: Icon(Icons.add),
                ),
              ],
            ),
          ),
          Transform.translate(
            offset: Offset(0, -8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Formats.monthDay(subscription.startDate),
                    style: style.caption,
                  ),
                  Text(
                    'TO',
                    style: style.overline,
                  ),
                  Text(
                    Formats.monthDay(subscription.endDate),
                    style: style.caption,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
