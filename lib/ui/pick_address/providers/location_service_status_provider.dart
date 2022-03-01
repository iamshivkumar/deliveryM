import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final _locationStatusProvider = StreamProvider<ServiceStatus>(
  (ref) {
    return Geolocator.getServiceStatusStream();
  },
);

final locationStatusProvider = FutureProvider<bool>(
  (ref) async {
    final statusData = ref.watch(_locationStatusProvider).value;
    if (statusData != null) {
      return Future.value(statusData == ServiceStatus.enabled);
    } else {
      return await Geolocator.isLocationServiceEnabled();
    }
  },
);
