import 'package:emddi_bus/constants/constant.dart';
import 'package:emddi_bus/network/bus_router.dart';
import 'package:emddi_bus/network/login.dart';
import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void login() async {
    await getToken();
    Navigator.pushReplacementNamed(context, '/map');
    await getBusRouter(token);
  }

  @override
  void initState() {
    super.initState();
    geoService.getInitialLocation();
    login();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff262626),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset('assets/loading.gif'),
          Text(
            'Connecting to Internet...',
            style: TextStyle(color: Colors.white),
          )
        ]),
      ),
    );
  }
}
