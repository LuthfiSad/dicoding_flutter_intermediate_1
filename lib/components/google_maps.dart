import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intermediate_flutter/components/placemark.dart';
import 'package:intermediate_flutter/provider/map_provider.dart';

class MyGoogleMaps extends StatefulWidget {
  const MyGoogleMaps({Key? key}) : super(key: key);

  @override
  State<MyGoogleMaps> createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<MyGoogleMaps> {
  late GoogleMapController mapController;

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MapProvider>(
      builder: (context, mapProvider, child) {
        return Scaffold(
          body: Stack(
            children: [
              GoogleMap(
                myLocationButtonEnabled: false,
                myLocationEnabled: true,
                zoomControlsEnabled: false,
                mapType: mapProvider.selectedMapType,
                markers: mapProvider.markers,
                initialCameraPosition: CameraPosition(
                  target: mapProvider.userLocation!,
                  zoom: 18,
                ),
                onLongPress: (LatLng latLng) {
                  mapProvider.onLongPressGoogleMaps(latLng, mapController);
                },
                onMapCreated: (controller) async {
                  mapProvider.initUserLocation();
                  mapController = controller;
                },
              ),
              // get my location
              Positioned(
                top: 16,
                right: 16,
                child: FloatingActionButton(
                  child: const Icon(Icons.my_location),
                  onPressed: () {
                    mapProvider.onGetMyLocation(mapController);
                  },
                ),
              ),
              // zoom in
              Positioned(
                bottom: 60,
                right: 5,
                child: FloatingActionButton.small(
                  heroTag: 'zoom-in',
                  child: const Icon(Icons.add),
                  onPressed: () {
                    mapController.animateCamera(
                      CameraUpdate.zoomIn(),
                    );
                  },
                ),
              ),
              // zoom out
              Positioned(
                bottom: 16,
                right: 5,
                child: FloatingActionButton.small(
                  heroTag: 'zoom-out',
                  child: const Icon(Icons.remove),
                  onPressed: () {
                    mapController.animateCamera(
                      CameraUpdate.zoomOut(),
                    );
                  },
                ),
              ),
              // map type
              Positioned(
                top: 16,
                right: 80,
                child: FloatingActionButton.small(
                  onPressed: null,
                  child: PopupMenuButton<MapType>(
                    icon: const Icon(Icons.map),
                    onSelected: (value) {
                      mapProvider.changeMapType(value);
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: MapType.normal,
                        child: Text("Normal"),
                      ),
                      const PopupMenuItem(
                        value: MapType.satellite,
                        child: Text("Satellite"),
                      ),
                      const PopupMenuItem(
                        value: MapType.terrain,
                        child: Text("Terrain"),
                      ),
                      const PopupMenuItem(
                        value: MapType.hybrid,
                        child: Text("Hybrid"),
                      ),
                    ],
                  ),
                ),
              ),
              if (mapProvider.placemark == null)
                const SizedBox()
              else
                Positioned(
                  bottom: 16,
                  right: 60,
                  left: 16,
                  child: Placemark(
                    placemark: mapProvider.placemark!,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
