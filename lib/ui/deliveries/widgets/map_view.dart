import 'package:delivery_m/core/enums/delivery_status.dart';
import 'package:delivery_m/core/models/subscription.dart';
import 'package:delivery_m/ui/customers/providers/customer_provider.dart';
import 'package:delivery_m/ui/deliveries/utils/generate.dart';
import 'package:delivery_m/ui/profile/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'delivery_card.dart';

final stateProvider = StateProvider<int>((ref) => 0);

final selectedStatProvider = StateProvider<DeliveryStat?>((ref)=>null);

class MapView extends ConsumerWidget {
  const MapView({
    Key? key,
    required this.date,
    required this.subscriptions,
  }) : super(key: key);
  final DateTime date;
  final List<Subscription> subscriptions;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.read(profileProvider).value!;
    final selected = ref.watch(selectedStatProvider.state);
    final state = ref.watch(stateProvider.state);
    final controller = DefaultTabController.of(context);
    controller!.addListener(() {
      state.state++;
    });
    final generate = Generate(
        date: date,
        subscriptions: subscriptions,
        status: [
          DeliveryStatus.pending,
          DeliveryStatus.delivered,
          DeliveryStatus.canceled,
        ][controller.index]);

    return Container(
      color: Colors.lightGreen.shade100,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                profile.address.point.latitude,
                profile.address.point.longitude,
              ),
              zoom: 14,
            ),
            onTap: (_){
              selected.state = null;
            },
            markers: generate.stats
                .map(
                  (e) => ref.watch(customerProvider(e.cId)).when(
                        data: (customer) => Marker(
                          markerId: MarkerId(e.subscriptions.first.id),
                          position: LatLng(
                            customer.address.point.latitude,
                            customer.address.point.longitude,
                          ),
                          onTap: (){
                            selected.state = e;
                          },
                          infoWindow: InfoWindow(
                            title: customer.name,
                            snippet: "Product 2"
                          )
                        ),
                        error: (err, s) => Marker(
                            markerId: MarkerId(e.subscriptions.first.id),
                            position: const LatLng(0, 0)),
                        loading: () => Marker(
                          markerId: MarkerId(e.subscriptions.first.id),
                          position: const LatLng(0, 0),
                        ),
                      ),
                )
                .toSet(),
          ),
         selected.state!=null? Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DeliveryCard(
                  deliveryStat: selected.state!,
                ),
              )
            ],
          ):const SizedBox()
        ],
      ),
    );
  }
}