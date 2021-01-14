import 'package:emddi_bus/network/bus_router.dart';
import 'package:flutter/material.dart';

class RouteDetail extends StatefulWidget {
  @override
  _RouteDetailState createState() => _RouteDetailState();
}

class _RouteDetailState extends State<RouteDetail> {
  @override
  Widget build(BuildContext context) {

    BusRouter data = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(data.name),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
        child: Center(
          child: Column(
            children: [
              Center(
                child: Text(
                  '${data.city}',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Center(
                child: Text(
                  '${data.description}',
                  style: TextStyle(
                      fontSize: 18
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
