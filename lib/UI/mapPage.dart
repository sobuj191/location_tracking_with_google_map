import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static const LatLng _StaffQuarter =
      LatLng(23.71964076444179, 90.49050525623353);
  static const LatLng _GUB = LatLng(23.8296064704205, 90.56672290495216);
  Location _locationController = new Location();
  LatLng? _currentPosistion = null;

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _currentPosistion == null
            ? const Center(
                child: Text("Loading..."),
              )
            : GoogleMap(
                onMapCreated: ((GoogleMapController controller) =>
                    _mapController.complete(controller)),
                initialCameraPosition:
                    CameraPosition(target: _StaffQuarter, zoom: 13),
                markers: {
                  Marker(
                      markerId: MarkerId("_currentLocation"),
                      icon: BitmapDescriptor.defaultMarker,
                      position: _currentPosistion!),
                  Marker(
                      markerId: MarkerId("_sourceLocation"),
                      icon: BitmapDescriptor.defaultMarker,
                      position: _StaffQuarter),
                  Marker(
                      markerId: MarkerId("_desrtinationLocation"),
                      icon: BitmapDescriptor.defaultMarker,
                      position: _GUB),
                },
              ));
  }

  Future<void> _cameraPosirtion(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(target: pos, zoom: 13);
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(_newCameraPosition),
    );
  }

  Future<void> getCurrentLocation() async {
    bool _serviceEnabled;
    PermissionStatus _perminssionStatus;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    _perminssionStatus = await _locationController.hasPermission();
    if (_perminssionStatus == PermissionStatus.denied) {
      _perminssionStatus = await _locationController.requestPermission();
      if (_perminssionStatus != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentPosistion =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          _cameraPosirtion(_currentPosistion!);
        });
      }
    });
  }
}
