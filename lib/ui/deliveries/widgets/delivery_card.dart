import '../../components/error.dart';
import '../../components/loading.dart';
import '../../customers/providers/customer_provider.dart';
import '../delivery_page.dart';
import '../utils/generate.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DeliveryCard extends ConsumerWidget {
  const DeliveryCard({Key? key, required this.deliveryStat}) : super(key: key);
  final DeliveryStat deliveryStat;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;

    return ref.watch(customerProvider(deliveryStat.cId)).when(
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
                           
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Chip(
                                label: RichText(
                                  text: TextSpan(
                                    text: '${e.product.name}:  ',
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
                                avatar: Image.asset(e.product.image),
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
