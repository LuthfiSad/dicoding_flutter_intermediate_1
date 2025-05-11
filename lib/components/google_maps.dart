import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intermediate_flutter/components/placemark.dart';
import 'package:intermediate_flutter/provider/map_provider.dart';

class MyGoogleMaps extends StatefulWidget {
  const MyGoogleMaps({super.key});

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
              Positioned(
                top: 16,
                right: 16,
                child: Column(
                  children: [
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
                    // FloatingActionButton(
                    //   heroTag: 'map-type',
                    //   backgroundColor: theme.colorScheme.primary,
                    //   child: Icon(Icons.layers,
                    //       color: theme.colorScheme.onPrimary),
                    //   onPressed: () {
                    //     showModalBottomSheet(
                    //       context: context,
                    //       builder: (context) => Container(
                    //         padding: const EdgeInsets.all(16),
                    //         child: Column(
                    //           mainAxisSize: MainAxisSize.min,
                    //           children: [
                    //             Text('Select Map Type',
                    //                 style: theme.textTheme.titleMedium),
                    //             const SizedBox(height: 16),
                    //             Wrap(
                    //               spacing: 8,
                    //               children: [
                    //                 MapTypeButton(
                    //                   icon: Icons.map,
                    //                   label: 'Normal',
                    //                   type: MapType.normal,
                    //                   currentType: mapProvider.selectedMapType,
                    //                   onPressed: () {
                    //                     mapProvider
                    //                         .changeMapType(MapType.normal);
                    //                     Navigator.pop(context);
                    //                   },
                    //                 ),
                    //                 MapTypeButton(
                    //                   icon: Icons.satellite,
                    //                   label: 'Satellite',
                    //                   type: MapType.satellite,
                    //                   currentType: mapProvider.selectedMapType,
                    //                   onPressed: () {
                    //                     mapProvider
                    //                         .changeMapType(MapType.satellite);
                    //                     Navigator.pop(context);
                    //                   },
                    //                 ),
                    //                 MapTypeButton(
                    //                   icon: Icons.terrain,
                    //                   label: 'Terrain',
                    //                   type: MapType.terrain,
                    //                   currentType: mapProvider.selectedMapType,
                    //                   onPressed: () {
                    //                     mapProvider
                    //                         .changeMapType(MapType.terrain);
                    //                     Navigator.pop(context);
                    //                   },
                    //                 ),
                    //                 MapTypeButton(
                    //                   icon: Icons.layers,
                    //                   label: 'Hybrid',
                    //                   type: MapType.hybrid,
                    //                   currentType: mapProvider.selectedMapType,
                    //                   onPressed: () {
                    //                     mapProvider
                    //                         .changeMapType(MapType.hybrid);
                    //                     Navigator.pop(context);
                    //                   },
                    //                 ),
                    //               ],
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // ),
                  ],
                ),
              ),
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
