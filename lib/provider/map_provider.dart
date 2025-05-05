import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:location/location.dart';
import 'package:intermediate_flutter/model/response/error_response.dart';

class MapProvider extends ChangeNotifier {
  late LatLng _userLocation;
  final Set<Marker> _markers = {};
  MapType _selectedMapType = MapType.normal;
  geo.Placemark? _placemark;
  final Location location = Location();

  LatLng? get userLocation => _userLocation;
  Set<Marker> get markers => _markers;
  MapType get selectedMapType => _selectedMapType;
  geo.Placemark? get placemark => _placemark;

  MapProvider() {
    initLatLng();
    initUserLocation();
  }

  void initLatLng() {
    _userLocation = const LatLng(-6.1753924, 106.8271528);
    notifyListeners();
  }

  void clearMarkerAndPlacemark() {
    _markers.clear();
    _placemark = null;
    notifyListeners();
  }

  Future<ErrorResponse> setUserLatLng(LatLng latLng) async {
    _userLocation = latLng;
    notifyListeners();

    try {
      final info = await geo.placemarkFromCoordinates(
        _userLocation.latitude,
        _userLocation.longitude,
      );
      final place = info[0];
      final street = place.street!;
      final address =
          '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

      _placemark = place;
      notifyListeners();

      defineMarker(latLng, street, address);

      return ErrorResponse(error: false, message: 'success');
    } catch (e) {
      return ErrorResponse(
        error: true,
        message: 'error location coordinate could not be found',
      );
    }
  }

  void initUserLocation() async {
    locationServiceChecker();
    late LocationData locationData;

    locationData = await location.getLocation();
    final latLng = LatLng(locationData.latitude!, locationData.longitude!);
    _userLocation = latLng;
    notifyListeners();
  }

  void locationServiceChecker() async {
    late bool serviceEnabled;
    late PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();

      if (!serviceEnabled) {
        throw ErrorResponse(error: true, message: 'Service location disabled');
      }
    }

    permissionGranted = await location.hasPermission();

    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();

      if (permissionGranted != PermissionStatus.granted) {
        throw ErrorResponse(error: true, message: 'Permission location denied');
      }
    }
  }

  void onGetMyLocation(GoogleMapController mapController) async {
    locationServiceChecker();
    late LocationData locationData;

    locationData = await location.getLocation();

    final latLng = LatLng(locationData.latitude!, locationData.longitude!);

    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    final place = info[0];
    final street = place.street!;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

    _placemark = place;
    notifyListeners();

    defineMarker(latLng, street, address);

    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }

  void defineMarker(LatLng latLng, String street, String address) {
    final marker = Marker(
      markerId: const MarkerId("source"),
      position: latLng,
      infoWindow: InfoWindow(
        title: street,
        snippet: address,
      ),
    );

    _markers.add(marker);
    notifyListeners();
  }

  void onLongPressGoogleMaps(
      LatLng latLng, GoogleMapController mapController) async {
    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    final place = info[0];
    final street = place.street!;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

    _placemark = place;
    _userLocation = latLng;
    notifyListeners();

    defineMarker(latLng, street, address);

    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }

  void addMarker(Marker markers) {
    _markers.add(markers);
    notifyListeners();
  }

  void changeMapType(MapType mapType) {
    _selectedMapType = mapType;
    notifyListeners();
  }

  void onMapTypeButtonPressed() {
    notifyListeners();
  }
}
