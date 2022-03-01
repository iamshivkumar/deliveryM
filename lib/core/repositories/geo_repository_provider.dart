import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/address.dart';
import '../models/search_result.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final geoReposioryProvider = Provider<GeoRepository>((ref) => GeoRepository());

class GeoRepository {
  static const String _key = "AIzaSyBjX5-R86SaWpsUsYToa2W93OXB4QDOcOM";

  GoogleMapsGeocoding get geocoding => GoogleMapsGeocoding(apiKey: _key);

  Future<Address> getAddress(LatLng point) async {
    final GeocodingResponse response = await geocoding
        .searchByLocation(Location(lat: point.latitude, lng: point.longitude));
    if (kDebugMode) {
      print(response.results.length);
    }

    if (response.errorMessage != null) {
      if (kDebugMode) {
        print(response.errorMessage);
      }
      return Address.empty();
    } else {
      final GeocodingResult result = response.results.first;
      return Address.empty().copyWith(
        city: result.addressComponents[2].shortName,
        area: result.addressComponents[1].shortName,
        number: result.addressComponents[0].shortName,
        point: GeoPoint(
          result.geometry.location.lat,
          result.geometry.location.lng,
        ),
        formated: result.formattedAddress,
      );
    }
  }

  Future<Address> getAddressById(String id) async {
    final places = GoogleMapsPlaces(apiKey: _key);
    final PlacesDetailsResponse response = await places.getDetailsByPlaceId(id);
    if (response.errorMessage != null) {
      if (kDebugMode) {
        print(response.errorMessage);
      }
      return Address.empty();
    } else {
      final PlaceDetails result = response.result;
      return Address.empty().copyWith(
        city: result.addressComponents[2].shortName,
        area: result.addressComponents[1].shortName,
        number: result.addressComponents[0].shortName,
        point: GeoPoint(
          result.geometry!.location.lat,
          result.geometry!.location.lng,
        ),
        formated: result.formattedAddress,
      );
    }
  }

  Future<List<SearchResult>> getSearchResults(String key) async {
    final places = GoogleMapsPlaces(apiKey: _key);
    final PlacesAutocompleteResponse response =
        await places.autocomplete(key, region: 'in');
    if (response.errorMessage != null) {
      return Future.error(response.errorMessage.toString());
    }
    return response.predictions
        .where((element) => element.placeId != null)
        .map(
          (e) => SearchResult(
            id: e.placeId!,
            subtitle: e.structuredFormatting?.secondaryText ?? '',
            title: e.structuredFormatting?.mainText ?? '',
          ),
        )
        .toList();
  }
}
