import 'package:emddi_bus/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class BottomButton extends StatefulWidget {
  @override
  _BottomButtonState createState() => _BottomButtonState();
}

class _BottomButtonState extends State<BottomButton> {
  Position currentPosition;
  Future<void> _getCurrentLocation() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        currentPosition = position;
      });
    });
  }

  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 25,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FloatingActionButton(
            heroTag: null,
            onPressed: () {
              Navigator.pushNamed(context, '/bus');
            },
            child: Icon(Icons.directions_bus),
            backgroundColor: Colors.lightBlueAccent,
          ),
          FloatingActionButton(
            heroTag: null,
            onPressed: () {
              //animateLocation(currentPosition.latitude, currentPosition.longitude, 17);
            },
            child: Icon(Icons.my_location),
            backgroundColor: Colors.white70,
          ),
          FloatingActionButton(
            heroTag: null,
            onPressed: () {
              // Navigator.pushNamed(context, '/user');
              mapType == MapType.normal
                  ? mapType = MapType.hybrid
                  : mapType = MapType.normal;
            },
            child: Icon(Icons.map),
            backgroundColor: Colors.lightBlueAccent,
          )
        ],
      ),
    );
  }
}
