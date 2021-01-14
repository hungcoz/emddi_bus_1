import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:emddi_bus/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

class GMap extends StatefulWidget {
  @override
  _GMapState createState() => _GMapState();
}

class _GMapState extends State<GMap> {
  CameraPosition _initialCameraPosition =
      CameraPosition(target: LatLng(16.521619, 108.964927), zoom: 5.3);

  Location _location = Location();
  bool _serviceEnable;
  PermissionStatus _permissionGranted;

  LocationData locationData;
  var latitude, longitude;

  Uint8List busStopIcon;

  void setCustomIcon() async {
    busStopIcon = await getBytesFromAsset('assets/bus_stop.png', 100);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  void _onMapCreated(GoogleMapController controller) {
    getUserLocation();
    markBusStop();
    _controller.complete(controller);
  }

  void markBusStop() {
    for (int i = 0; i < listBusStop.length; i++) {
      _markers.add(Marker(
        markerId: MarkerId('${listBusStop[i].name}'),
        position: LatLng(listBusStop[i].latitude, listBusStop[i].longitude),
        icon: BitmapDescriptor.fromBytes(busStopIcon),
        anchor: Offset(0.5, 0.5),
        infoWindow: InfoWindow(title: '${listBusStop[i].name}'),
        onTap: () => {
          animateLocation(
              listBusStop[i].latitude, listBusStop[i].longitude, 16),
          Duration(milliseconds: 500),
        },

        // consumeTapEvents: true,
      ));
    }
  }

  Set<Marker> _markers = {};

  Future<void> getUserLocation() async {
    _serviceEnable = await _location.serviceEnabled();
    if (!_serviceEnable) {
      _serviceEnable = await _location.requestService();
      if (!_serviceEnable) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await _location.getLocation();
    lat = locationData.latitude;
    long = locationData.longitude;
    latitude = locationData.latitude;
    longitude = locationData.longitude;
    animateLocation(lat, long, 16);

    _location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        lat = currentLocation.latitude;
        long = currentLocation.longitude;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    setCustomIcon();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          setState(() {
            _onMapCreated(controller);
          });
        },
        mapType: MapType.satellite,
        initialCameraPosition: _initialCameraPosition,
        myLocationEnabled: true,
        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
        mapToolbarEnabled: false,
        compassEnabled: false,
        markers: _markers,
    );
  }
}

var lat = 0.0, long = 0.0;
Completer<GoogleMapController> _controller = Completer();

void animateLocation(double lat, double long, double zoom) async {
  final GoogleMapController controller = await _controller.future;
  controller.animateCamera(CameraUpdate.newCameraPosition(
    CameraPosition(
      target: LatLng(lat, long),
      zoom: zoom,
    ),
  ));
}

// void moveToLocation(double lat, double long, double zoom) async {
//   final GoogleMapController controller = await _controller.future;
//   controller.moveCamera(CameraUpdate.newCameraPosition(
//     CameraPosition(
//       target: LatLng(lat, long),
//       zoom: zoom,
//     ),
//   ));
// }
