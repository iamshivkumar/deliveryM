import '../../../core/models/address.dart';
import '../providers/pick_address_view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../pick_address_page.dart';

final controllerProvider = StateProvider<GoogleMapController?>((ref)=>null);
// ignore: must_be_immutable
class PickedAddressCard extends ConsumerWidget {
  const PickedAddressCard({Key? key, required this.address, required this.onChanged})
      : super(key: key);

  final Address address;

  final ValueChanged<Address> onChanged;


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(controllerProvider.state);
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 2,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  address.point.latitude,
                  address.point.longitude,
                ),
                zoom: 14,
              ),
              markers: {
                Marker(
                    markerId: const MarkerId('0'),
                    position: LatLng(
                      address.point.latitude,
                      address.point.longitude,
                    ))
              },
              onMapCreated: (v){
                controller.state = v;
              },
            ),
          ),
          ListTile(
            dense: true,
            title: Text(
              '${address.number}, ${address.area}, ${address.city}',
            ),
            trailing: IconButton(
              onPressed: () async {
                ref.read(pickAddressViewModelProvider).address = address;
                final Address? picked = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PickAddressPage(),
                  ),
                );
                if (picked != null) {
                  onChanged(picked);
                  if (controller.state != null) {
                    controller.state!
                        .animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: LatLng(
                                picked.point.latitude,
                                picked.point.longitude,
                              ),
                              zoom: 14,
                            ),
                          ),
                        );
                  }
                }
              },
              icon: const Icon(Icons.edit),
            ),
          )
        ],
      ),
    );
  }
}
