import 'package:emddi_bus/constants/constant.dart';
import 'package:emddi_bus/pages/map/ggmap.dart';
import 'package:emddi_bus/pages/map/search_box.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff262626),
      body: FutureProvider(
        create: (context) => geoService.getInitialLocation(),
        child: Consumer<Position>(
          builder: (context, position, widget) {
            return (position != null)
                ? GMap(
                    initialPosition: position,
                  )
                : Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/loading.gif'),
                          Text(
                            'Connecting to Internet...',
                            style: TextStyle(color: Colors.white),
                          )
                        ]),
                  );
          },
        ),
      ),
    );
  }
}
