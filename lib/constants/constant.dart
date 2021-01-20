import 'package:emddi_bus/network/bus_router.dart';
import 'package:emddi_bus/network/location_service.dart';
import 'package:emddi_bus/pages/bus/bus_stop.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

String token = '';
String url = 'https://emdbusapi.emddi.com/api';

MapType mapType = MapType.normal;

final geoService = GeolocatorService();

//Position currentPosition;

List<BusRouter> busRouters = [];

List<BusStop> busStop = [
  BusStop(
      name: 'Nhà khách Chính phủ',
      latitude: 21.026463,
      longitude: 105.855659,
      routerId: [1, 2, 3]),
  BusStop(
      name: 'Vườn hoa Lênin',
      latitude: 21.032294,
      longitude: 105.839528,
      routerId: [1]),
  BusStop(
      name: 'Hoàng Diệu',
      latitude: 21.0335833,
      longitude: 105.8390984,
      routerId: [1]),
  BusStop(
      name: 'Vườn hoa Lý Tự Trọng',
      latitude: 21.0430283,
      longitude: 105.835951,
      routerId: [1]),
  BusStop(
      name: 'Chùa Trấn Quốc',
      latitude: 21.0481377,
      longitude: 105.835951,
      routerId: [1]),
  BusStop(
      name: 'Ngã tư Lê Hồng Phong - Chu Văn An',
      latitude: 21.033662,
      longitude: 105.836638,
      routerId: [2]),
  BusStop(
      name: 'Ngã tư Nguyễn Thái Học - Tôn Đức Thắng',
      latitude: 21.030366,
      longitude: 105.836084,
      routerId: [2]),
  BusStop(
      name: 'Bảo tàng Công an Hà Nội',
      latitude: 21.024697,
      longitude: 105.845832,
      routerId: [2]),
  BusStop(
      name: 'Nhà thờ lớn Hà Nội',
      latitude: 21.028894,
      longitude: 105.849503,
      routerId: [2]),
  BusStop(
      name: '40 Lý Thường Kiệt',
      latitude: 21.023120,
      longitude: 105.851203,
      routerId: [2]),
  BusStop(
      name: 'Quảng trường CMT8',
      latitude: 21.024153,
      longitude: 105.857194,
      routerId: [2]),
];
