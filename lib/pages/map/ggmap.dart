import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:emddi_bus/constants/constant.dart';
import 'package:emddi_bus/pages/bus/bus_stop.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';

class GMap extends StatefulWidget {
  final Position initialPosition;

  GMap({Key key, this.initialPosition}) : super(key: key);

  @override
  _GMapState createState() => _GMapState();
}

class _GMapState extends State<GMap> {
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
    //getUserLocation();
    markBusStop();
    _controller.complete(controller);
  }

  void markBusStop() {
    for (int i = 0; i < busStop.length; i++) {
      _markers.add(Marker(
        markerId: MarkerId('${busStop[i].name}'),
        position: LatLng(busStop[i].latitude, busStop[i].longitude),
        icon: BitmapDescriptor.fromBytes(busStopIcon),
        anchor: Offset(0.5, 0.5),
        infoWindow: InfoWindow(title: '${busStop[i].name}'),
        onTap: () => {
          animateLocation(busStop[i].latitude, busStop[i].longitude, 16),
          Duration(milliseconds: 500),
        },

        // consumeTapEvents: true,
      ));
    }
  }

  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    setCustomIcon();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            setState(() {
              _onMapCreated(controller);
            });
          },
          mapType: mapType,
          initialCameraPosition: CameraPosition(
              target: LatLng(widget.initialPosition.latitude,
                  widget.initialPosition.longitude),
              zoom: 15),
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          mapToolbarEnabled: false,
          compassEnabled: false,
          markers: _markers,
        ),
        button(),
        _search()
      ]),
    );
  }

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

  Widget button() {
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
              animateLocation(
                  currentPosition.latitude, currentPosition.longitude, 17);
            },
            child: Icon(Icons.my_location),
            backgroundColor: Colors.white70,
          ),
          FloatingActionButton(
            heroTag: null,
            onPressed: () {
              // Navigator.pushNamed(context, '/user');
              if (mapType == MapType.normal) {
                setState(() {
                  mapType = MapType.hybrid;
                });
              } else {
                setState(() {
                  mapType = MapType.normal;
                });
              }
            },
            child: Icon(Icons.map),
            backgroundColor: Colors.lightBlueAccent,
          )
        ],
      ),
    );
  }

  bool _isSearching = false;

  List<BusStop> listBusStop = new List();

  TextEditingController searchController = TextEditingController();

  Widget listResult() {
    return _isSearching
        ? Container(
            //color: Colors.red,
            //height: 200,
            constraints: BoxConstraints(maxHeight: 200),
            child: listBusStop.length > 0
                ? ListView.builder(
                    padding: EdgeInsets.only(top: 0),
                    itemCount: listBusStop.length,
                    itemBuilder: (context, index) =>
                        buildBusStopCard(context, index),
                    shrinkWrap: true,
                  )
                : Container(
                    height: 30,
                    child: Center(
                      child: Text(
                        'Không tìm thấy kết quả',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
          )
        : null;
  }

  Widget buildBusStopCard(BuildContext context, int index) {
    BusStop busStop = listBusStop[index];
    return Column(
        //color: Colors.grey[200],
        children: [
          ListTile(
            onTap: () {
              animateLocation(busStop.latitude, busStop.longitude, 16);
              setState(() {
                _isSearching = false;
                searchController.text = busStop.name;
                searchController.selection = TextSelection.fromPosition(
                    TextPosition(offset: searchController.text.length));
              });
            },
            title: Text(
              '${busStop.name}',
              style: TextStyle(fontSize: 18),
            ),
            subtitle: Text('Tuyến chạy qua: ${busStop.routerId.toString()}'),
          ),
          Container(
            height: 1,
            color: Colors.grey[200],
          )
        ]);
  }

  void search(String value) {
    if (value.isNotEmpty) {
      List<BusStop> dummyData = <BusStop>[];
      busStop.forEach((element) {
        if (element.name.toLowerCase().contains(value.toLowerCase())) {
          dummyData.add(element);
        }
      });
      setState(() {
        listBusStop.clear();
        listBusStop.addAll(dummyData);
      });
      return;
    } else {
      setState(() {
        listBusStop.clear();
      });
    }
  }

  Widget _search() {
    return Positioned(
      top: 40,
      right: 15,
      left: 15,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(color: Colors.grey[800], width: 2),
        ),
        child: Column(children: [
          TextField(
            style: TextStyle(fontSize: 18),
            controller: searchController,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              hintText: 'Tìm kiếm điểm dừng...',
              hintStyle: TextStyle(fontSize: 18),
              suffixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              setState(() {
                _isSearching = value.isNotEmpty;
              });
              search(value);
            },
            onSubmitted: (value) {
              setState(() {
                _isSearching = false;
              });
            },
          ),
          //SizedBox(height: 5,)],
          Container(
            child: _isSearching ? listResult() : null,
          )
        ]),
      ),
    );
  }
}

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
