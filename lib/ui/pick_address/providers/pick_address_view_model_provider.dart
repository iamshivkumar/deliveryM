import 'package:android_intent/android_intent.dart';
import 'package:delivery_m/core/models/address.dart';
import 'package:delivery_m/core/repositories/geo_repository_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../utils/labels.dart';

final writeAddressViewModelProvider =
    ChangeNotifierProvider((ref) => WriteAddressModel(ref));

class WriteAddressModel extends ChangeNotifier {
  final Ref ref;
  WriteAddressModel(this.ref);

  GoogleMapController? mapController;

  GeoRepository get _geo => ref.read(geoReposioryProvider);
  

  MapType type = MapType.normal;
  
  void toggleMapType(){
    if(type==MapType.normal){
      type = MapType.hybrid;
    } else {
      type = MapType.normal;
    }
    notifyListeners();
  }

  LatLng _latLng = LatLng(18.5204, 73.8567);
  LatLng get latLng => _latLng;

  set latLng(LatLng v) {
    _latLng = v;
    notifyListeners();
    try {
      _geo.getAddress(v).then((value) {
        address = value;
      });
    } catch (e) {
      print(e);
    }
  }

  LatLng? _markerPosition;
  set markerPosition(LatLng? markerPosition) {
    _markerPosition = markerPosition;
    latLng = markerPosition!;
    notifyListeners();
  }
  

 Set<Marker> get markers => _markerPosition!=null?{
   Marker(
        draggable: true,
        markerId: MarkerId('Marker'),
        position: LatLng(_markerPosition!.latitude, _markerPosition!.longitude),
        onDragEnd: ((newPosition) {
          latLng = newPosition;
          markerPosition = newPosition;
        }),
      )
 }:{};

  String _number = '';
  String get number =>_number.isNotEmpty?_number: address?.number??'';
  set number(String number) {
    _number = number;
    notifyListeners();
  }





  Address? _address;
  Address? get address => _address;
  set address(Address? address) {
    _address = address;
    _latLng = LatLng(address!.point.latitude, address.point.longitude);
    _markerPosition  = _latLng;
    if (mapController != null) {
      mapController!.animateCamera(CameraUpdate.newLatLng(latLng));
    }
    notifyListeners();
  }

  Future<void> addAddress({required bool edit}) async {
   
  }

  void handleLocateMe(bool enabled) async {
    if (enabled) {
      LocationPermission permission;
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        }
      }
      if (permission == LocationPermission.deniedForever) {
         print(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
      final Position position = await Geolocator.getCurrentPosition();
      latLng = LatLng(position.latitude, position.longitude);
      markerPosition = latLng;
      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newLatLng(latLng),
        );
      }
    } else {
      const intent =  AndroidIntent(
        action: 'android.settings.LOCATION_SOURCE_SETTINGS',
      );
      await intent.launch();
    }
  }
}
