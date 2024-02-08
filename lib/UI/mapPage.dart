import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static const LatLng _pGooglePlex = LatLng(23.777176, 90.399452);
  static const LatLng _pWebPark = LatLng(23.877176, 90.499452);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GoogleMap(
      initialCameraPosition: CameraPosition(target: _pGooglePlex, zoom: 13),
      markers: {
        Marker(
            markerId: MarkerId("_currentLocation"),
            icon: BitmapDescriptor.defaultMarker,
            position: _pGooglePlex),
        Marker(
            markerId: MarkerId("_sourceLocation"),
            icon: BitmapDescriptor.defaultMarker,
            position: _pWebPark),
      },
    ));
  }
}
