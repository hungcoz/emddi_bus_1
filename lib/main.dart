import 'package:emddi_bus/pages/bus/bus_route_details.dart';
import 'package:emddi_bus/pages/bus/listbus.dart';
import 'package:emddi_bus/pages/loading.dart';
import 'package:emddi_bus/pages/map/toolbar.dart';
import 'package:emddi_bus/pages/user/user_inf.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Loading(),
    routes: {
      '/loading': (context) => Loading(),
      '/map': (context) => Toolbar(),
      '/bus': (context) => ListBus(),
      '/user': (context) => User(),
      '/route_detail': (context) => RouteDetail(),
    },
  ));
}