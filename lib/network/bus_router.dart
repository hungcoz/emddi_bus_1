import 'dart:convert';

import 'package:emddi_bus/constants/constant.dart';
import 'package:http/http.dart' as http;

String urlRouter = url + "/router";

class ListRoutes {
  int code;
  String message;
  List<BusRouter> busRouters;

  ListRoutes({this.code, this.message, this.busRouters});

  factory ListRoutes.fromJson(Map<String, dynamic> json) {
    if (json['code'] == 0) {
      var listBusRouters = json['data']['list_routes'] as List;
      List<BusRouter> _busRouters =
          listBusRouters.map((e) => BusRouter.fromJson(e)).toList();
      return ListRoutes(
          code: json['code'],
          message: json['message'],
          busRouters: _busRouters);
    } else {
      throw Exception(json['message']);
    }
  }
}

class BusRouter {
  int routerId;
  String name;
  int officeId;
  String city;
  String description;
  String distance;
  String startTime;
  String endTime;
  String startPoint;
  String endPoint;

  BusRouter(
      {this.routerId,
      this.name,
      this.officeId,
      this.city,
      this.description,
      this.distance,
      this.startTime,
      this.endTime,
      this.startPoint,
      this.endPoint});

  factory BusRouter.fromJson(dynamic json) => BusRouter(
        routerId: json["router_id"],
        name: json["name"],
        description: json["description"],
        distance: json["distance"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        startPoint: json["start_point"],
        endPoint: json["end_point"],
        officeId: json["office_id"],
        city: json["city"],
      );
}

ListRoutes listRoutesFromJson(String str) =>
    ListRoutes.fromJson(json.decode(str));

Future<void> getBusRouter(String token) async {
  final response =
      await http.get(urlRouter, headers: {"x-access-token": token});
  if (response.statusCode == 200) {
    var result = listRoutesFromJson(response.body);
    busRouters = result.busRouters;
  } else
    throw Exception('Failed to load routes from API');
}
