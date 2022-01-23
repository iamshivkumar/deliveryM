import 'package:delivery_m/core/models/customer.dart';
import 'package:delivery_m/ui/components/error.dart';
import 'package:delivery_m/ui/components/loading.dart';
import 'package:delivery_m/ui/customers/providers/customer_subscriptions_provider.dart';
import 'package:delivery_m/ui/subscriptions/create_subscription_page.dart';
import 'package:delivery_m/ui/subscriptions/widgets/subscription_card.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomerPage extends ConsumerWidget {
  const CustomerPage({Key? key, required this.customer}) : super(key: key);

  final Customer customer;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionsStream =
        ref.watch(customerSubscriptionsProvider(customer.id));
    return Scaffold(
      appBar: AppBar(
        title: Text(customer.name),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateSubscriptionPage(
                customer: customer,
              ),
            ),
          );
        },
        label: const Text('Subscription'),
        icon: const Icon(Icons.add),
      ),
      body: ListView(
        children: <Widget>[] +
            subscriptionsStream.when(
              data: (subscriptions) => subscriptions
                  .map(
                    (e) => CustSubscriptionCard(subscription: e),
                  )
                  .toList(),
              error: (e, s) => [DataError(e: e)],
              loading: () => [
                const Loading(),
              ],
            ) +
            [
              Card(
                child: Column(
                  children: [
                    ListTile(
                      title: Text('${customer.balance}'),
                      leading: const Icon(Icons.account_balance_wallet),
                      trailing: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.add),
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                child: ListTile(
                  title: Text('+91${customer.mobile}'),
                  leading: const Icon(Icons.call),
                  trailing: const Icon(Icons.keyboard_arrow_right),
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
                      trailing: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.edit),
                      ),
                    ),
                  ],
                ),
              ),
            ],
      ),
    );
  }
}
