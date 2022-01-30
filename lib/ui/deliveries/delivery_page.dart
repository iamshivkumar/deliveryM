import '../../core/models/customer.dart';
import '../customers/providers/customer_provider.dart';
import 'utils/generate.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'widgets/delivery_product_widget.dart';

class DeliveryPage extends ConsumerWidget {
  const DeliveryPage({Key? key, required this.c, required this.stat})
      : super(key: key);

  final Customer c;
  final DeliveryStat stat;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final theme = Theme.of(context);
    // final style = theme.textTheme;
    final customer = ref.watch(customerProvider(c.id)).value ?? c;
    return Scaffold(
      appBar: AppBar(
        title: Text(customer.name),
      ),
      body: ListView(
        children: <Widget>[] +
            stat.subscriptions
                .map(
                  (e) => DeliveryProductWidget(
                    subscription: e,
                    date: stat.date,
                  ),
                )
                .toList() +
            [
               
              Card(
                child: ListTile(
                  onTap: () {},
                  title: Text(customer.mobile),
                  leading: const Icon(Icons.call),
                  trailing: const Icon(Icons.keyboard_arrow_right),
                ),
              ),
              Card(
                child: ListTile(
                  // onTap: () {},
                  title: Text("\$${customer.balance}"),
                  leading: const Icon(Icons.account_balance_wallet),
                  // trailing: const Icon(Icons.keyboard_arrow_right),
                ),
              ),
              Card(
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 2,
                      child: GoogleMap(
                        liteModeEnabled: true,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            customer.address.point.latitude,
                            customer.address.point.longitude,
                          ),
                          zoom: 14,
                        ),
                        markers: {
                          Marker(
                            markerId: const MarkerId('0'),
                            position: LatLng(
                              customer.address.point.latitude,
                              customer.address.point.longitude,
                            ),
                          ),
                        },
                      ),
                    ),
                    ListTile(
                      title: Text(customer.address.formated),
                      trailing: const Icon(Icons.open_in_new),
                    ),
                  ],
                ),
              ),
            ],
      ),
    );
  }
}
