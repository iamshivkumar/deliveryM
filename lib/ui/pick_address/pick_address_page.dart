import 'package:delivery_m/ui/pick_address/providers/location_service_status_provider.dart';

import 'providers/pick_address_view_model_provider.dart';
import 'search_address_page.dart';
import 'widgets/update_address_sheet.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../customers/widgets/my_circle_button.dart';

class PickAddressPage extends ConsumerWidget {
  const PickAddressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final model = ref.watch(pickAddressViewModelProvider);

    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    GoogleMap(
                      mapType: model.type,
                      onMapCreated: (controller) =>
                          model.mapController = controller,
                      initialCameraPosition: CameraPosition(
                        target: model.latLng,
                        zoom: 14,
                      ),
                      markers: model.markers,
                      onTap: (point) => model.markerPosition = point,
                    ),
                    Positioned(
                      right: 12,
                      bottom: 108,
                      child: Consumer(
                        builder: (context, ref, child) {
                          final status = ref.watch(locationStatusProvider);
                          return MyCircleButton(
                            icon: Icon(status.asData == null || !status.value!
                                ? Icons.gps_off
                                :  Icons.gps_not_fixed),
                            onTap: () {
                              model.handleLocateMe(status.value!);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              model.address != null
                  ? Material(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              model.address!.area,
                              style: style.headline6,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              model.address!.formated,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) =>
                                      const UpdateAddressSheet(),
                                );
                              },
                              child: const Text('CONTINUE'),
                            )
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: MyCircleButton(
                      icon: const Icon(
                        Icons.arrow_back,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Expanded(
                    child: Card(
                      shape: const StadiumBorder(),
                      child: InkWell(
                        onTap: () {
                          showSearch(context: context, delegate: SearchPage());
                        },
                        child: SizedBox(
                          height: 40,
                          child: Center(
                            child: Row(
                              children: const [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Text('Search Your Location'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: MyCircleButton(
                      icon: const Icon(
                        Icons.layers_outlined,
                      ),
                      onTap: model.toggleMapType,
                    ),
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
