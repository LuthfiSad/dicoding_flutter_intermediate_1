import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intermediate_flutter/components/placemark.dart';
import 'package:intermediate_flutter/provider/map_provider.dart';

class MyGoogleMaps extends StatefulWidget {
  final Function showMapTypeSelection;
  const MyGoogleMaps({super.key, required this.showMapTypeSelection});

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
    final theme = Theme.of(context);

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

              // Map Controls Container
              Positioned(
                top: 16,
                right: 16,
                child: Column(
                  children: [
                    // My Location Button
                    FloatingActionButton(
                      heroTag: 'my-location',
                      backgroundColor: theme.colorScheme.primary,
                      child: Icon(Icons.my_location,
                          color: theme.colorScheme.onPrimary),
                      onPressed: () {
                        mapProvider.onGetMyLocation(mapController);
                      },
                    ),
                    const SizedBox(height: 8),
                    // Map Type Button
                    FloatingActionButton(
                          heroTag: 'map-type',
                          backgroundColor: theme.colorScheme.primary,
                          child: Icon(Icons.layers,
                              color: theme.colorScheme.onPrimary),
                          onPressed: () {
                            widget.showMapTypeSelection();
                          },
                        )
                  ],
                ),
              ),

              // Zoom Controls
              Positioned(
                bottom: 16,
                right: 16,
                child: Column(
                  children: [
                    FloatingActionButton.small(
                      heroTag: 'zoom-in',
                      backgroundColor: theme.colorScheme.primary,
                      child:
                          Icon(Icons.add, color: theme.colorScheme.onPrimary),
                      onPressed: () {
                        mapController.animateCamera(CameraUpdate.zoomIn());
                      },
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton.small(
                      heroTag: 'zoom-out',
                      backgroundColor: theme.colorScheme.primary,
                      child: Icon(Icons.remove,
                          color: theme.colorScheme.onPrimary),
                      onPressed: () {
                        mapController.animateCamera(CameraUpdate.zoomOut());
                      },
                    ),
                  ],
                ),
              ),

              // Placemark
              if (mapProvider.placemark != null)
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 80,
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

class MapTypeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final MapType type;
  final MapType currentType;
  final VoidCallback onPressed;

  const MapTypeButton({
    super.key,
    required this.icon,
    required this.label,
    required this.type,
    required this.currentType,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = type == currentType;
    return ChoiceChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onPressed(),
    );
  }
}
