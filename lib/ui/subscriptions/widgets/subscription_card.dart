import '../../../core/enums/delivery_status.dart';
import '../../../core/models/subscription.dart';
import '../../products/providers/products_provider.dart';
import '../subscription_page.dart';
import '../../../utils/formats.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// class SubscriptionCard extends StatelessWidget {
//   const SubscriptionCard({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final style = theme.textTheme;
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     '9 Dec',
//                     style: style.caption,
//                   ),
//                   Text(
//                     'TO',
//                     style: style.overline,
//                   ),
//                   Text(
//                     '1 Jan',
//                     style: style.caption,
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       'Customer Name',
//                       style: style.bodyText1,
//                     ),
//                   ),
//                   Text('Area')
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Text('Product Name'),
//                   ),
//                   Text(
//                     '\$100',
//                     style: style.subtitle2,
//                   )
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8),
//               child: Stack(
//                 children: [
//                   Container(
//                     height: 4,
//                     color: theme.dividerColor,
//                   ),
//                   Container(
//                     width: 100,
//                     height: 4,
//                     color: Colors.green,
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

class CustSubscriptionCard extends ConsumerWidget {
  const CustSubscriptionCard({
    Key? key,
    this.enabled = true,
    required this.subscription,
  }) : super(key: key);

  final Subscription subscription;
  final bool enabled;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;

    final products = ref
            .watch(productsProvider)
            .asData
            ?.value
            .where((element) => element.id == subscription.productId) ??
        [];

    return GestureDetector(
      onTap: enabled? (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>SubscriptionPage(cId: subscription.customerId,sId: subscription.id)));
      }:null,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(products.isNotEmpty ? products.first.name : ""),
                    ),
                    Text(
                      '\$${subscription.price}',
                      style: style.subtitle2,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      flex: subscription.deliveries
                          .where((element) =>
                              element.status == DeliveryStatus.delivered)
                          .length,
                      child: Container(
                        height: 4,
                        color: Colors.green,
                      ),
                    ),
                    Expanded(
                      flex: subscription.deliveries
                          .where((element) =>
                              element.status == DeliveryStatus.pending)
                          .length,
                      child: Container(
                        height: 4,
                        color: theme.dividerColor,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
