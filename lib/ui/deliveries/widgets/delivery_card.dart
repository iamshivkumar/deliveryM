import 'package:delivery_m/ui/components/error.dart';
import 'package:delivery_m/ui/components/loading.dart';
import 'package:delivery_m/ui/customers/providers/customer_provider.dart';
import 'package:delivery_m/ui/deliveries/delivery_page.dart';
import 'package:delivery_m/ui/deliveries/utils/generate.dart';
import 'package:delivery_m/ui/products/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DeliveryCard extends ConsumerWidget {
  const DeliveryCard({Key? key, required this.deliveryStat}) : super(key: key);
  final DeliveryStat deliveryStat;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final products = ref.watch(productsProvider).value!;

    return ref.read(customerProvider(deliveryStat.cId)).when(
          data: (customer) => GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>  DeliveryPage(
                    c: customer,
                    stat: deliveryStat,
                  ),
                ),
              );
            },
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(customer.name),
                    subtitle: Text(customer.address.formated),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -8),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: deliveryStat.subscriptions.map((e) {
                            final filtered = products
                                .where((element) => element.id == e.productId);
                            final product =
                                filtered.isNotEmpty ? filtered.first : null;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Chip(
                                label: RichText(
                                  text: TextSpan(
                                    text: '${product?.name ?? "unknown"}:  ',
                                    style: style.caption,
                                    children: [
                                      TextSpan(
                                        text:
                                            "${e.getDelivery(deliveryStat.date).quantity}",
                                        style: style.subtitle2,
                                      ),
                                    ],
                                  ),
                                ),
                                avatar: product != null
                                    ? Image.network(product.image)
                                    : const Icon(Icons.info_outline),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          error: (e, s) => DataError(e: e),
          loading: () => const Loading(),
        );
  }
}
