import 'package:delivery_m/core/models/address.dart';
import 'package:delivery_m/ui/pick_address/pick_address_page.dart';
import 'package:delivery_m/ui/home/home_page.dart';
import 'package:delivery_m/ui/pick_address/providers/pick_address_view_model_provider.dart';
import 'package:delivery_m/ui/start/providers/register_view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RegisterPage extends ConsumerWidget {
  RegisterPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(registerViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Register your business'),
      ),
      floatingActionButton: model.address!=null? FloatingActionButton.extended(
        onPressed: () {
          if(_formKey.currentState!.validate()){
            _formKey.currentState!.save();
            model.register();
            Navigator.pop(context);
          }
        },
        label: Text('CONTINUE'),
      ):SizedBox(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: model.firstname,
                  onSaved: (v) => model.firstname = v!,
                  validator: (v) => v!.isEmpty ? "Enter first name" : null,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: model.lastname,
                  onSaved: (v) => model.lastname = v!,
                  validator: (v) => v!.isEmpty ? "Enter last name" : null,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: model.businessName,
                  onSaved: (v) => model.businessName = v!,
                  validator: (v) => v!.isEmpty ? "Enter business name" : null,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Business Name',
                  ),
                ),
                SizedBox(height: 16),
                model.address != null
                    ? Card(
                        margin: EdgeInsets.zero,
                        child: Column(
                          children: [
                            AspectRatio(
                              aspectRatio: 2,
                              child: GoogleMap(
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                    model.address!.point.latitude,
                                    model.address!.point.longitude,
                                  ),
                                  zoom: 14,
                                ),
                                markers: {
                                  Marker(
                                      markerId: MarkerId('0'),
                                      position: LatLng(
                                        model.address!.point.latitude,
                                        model.address!.point.longitude,
                                      ))
                                },
                              ),
                            ),
                            ListTile(
                              dense: true,
                              title: Text(
                                '${model.address!.number}, ${model.address!.area}, ${model.address!.city}',
                              ),
                              trailing: IconButton(
                                onPressed: () async {
                                  ref.read(pickAddressViewModelProvider).address = model.address!;
                                  final Address? address = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PickAddressPage(),
                                    ),
                                  );
                                  if (address != null) {
                                    model.address = address;
                                  }
                                },
                                icon: Icon(Icons.edit),
                              ),
                            )
                          ],
                        ),
                      )
                    : Card(
                        margin: EdgeInsets.zero,
                        child: ListTile(
                          onTap: () async {
                            final Address? address = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PickAddressPage(),
                              ),
                            );
                            if (address != null) {
                              model.address = address;
                            }
                          },
                          leading: Icon(Icons.location_pin),
                          title: Text('Pick Location'),
                          trailing: Icon(Icons.keyboard_arrow_right),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
