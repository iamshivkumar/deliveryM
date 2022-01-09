import 'package:delivery_m/ui/pick_address/providers/pick_address_view_model_provider.dart';
import 'package:delivery_m/ui/pick_address/search_address_page.dart';
import 'package:delivery_m/utils/labels.dart';
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
    final model = ref.watch(writeAddressViewModelProvider);

    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: GoogleMap(
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
                            SizedBox(height: 16),
                            Text(
                              model.address!.formated,
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {},
                              child: Text('CONTINUE'),
                            )
                          ],
                        ),
                      ),
                    )
                  : SizedBox(),
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
                      icon: Icon(
                        Icons.arrow_back,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Expanded(
                    child: Card(
                      shape: StadiumBorder(),
                      child: InkWell(
                        onTap: () {
                          showSearch(context: context, delegate: SearchPage());
                        },
                        child: SizedBox(
                          height: 40,
                          child: Center(
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
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
                      icon: Icon(
                        Icons.layers_outlined,
                      ),
                      onTap: model.toggleMapType,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
