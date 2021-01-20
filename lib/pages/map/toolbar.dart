import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:emddi_bus/constants/constant.dart';
import 'package:emddi_bus/pages/bus/bus_stop.dart';
import 'package:flutter/material.dart';
import 'ggmap.dart';

class Toolbar extends StatefulWidget {
  @override
  _ToolbarState createState() => _ToolbarState();
}

class _ToolbarState extends State<Toolbar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(children: [
        GMap(),
        searchBox(),
        // Container(
        //   alignment: Alignment.bottomCenter,
        //   padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
        //   child: Text('$lat $long'),
        // ),
        bottomButton(),
      ]),
    );
  }

  Widget searchBox() {
    return Positioned(
      top: 40,
      right: 15,
      left: 15,
      child: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              border: Border.all(color: Colors.grey, width: 2)),
          child: AutoCompleteTextField<BusStop>(
            decoration: InputDecoration(
              hintText: 'Tìm kiếm điểm dừng',
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 15, top: 15),
              suffixIcon: Icon(Icons.search),
            ),
            suggestions: busStop,
            itemSubmitted: (item) =>
                //animateLocation(item.latitude, item.longitude, 16),
                print('object'),
            key: GlobalKey<AutoCompleteTextFieldState<BusStop>>(),
            itemBuilder: (context, busStop) => Padding(
              child: ListTile(
                title: Text(busStop.name),
              ),
              padding: EdgeInsets.all(8.0),
            ),
            itemSorter: (a, b) => a.name.compareTo(b.name),
            // (sqrt(pow(a.latitude - lat, 2) +
            //             pow(a.longitude - long, 2)) ==
            //         sqrt(pow(b.latitude - lat, 2) +
            //             pow(b.longitude - long, 2)))
            //     ? 0
            //     : (sqrt(pow(a.latitude - lat, 2) +
            //                 pow(a.longitude - long, 2)) >
            //             (sqrt(pow(b.latitude - lat, 2) +
            //                 pow(b.longitude - long, 2))))
            //         ? -1
            //         : 1,
            itemFilter: (busStop, query) => filter(busStop, query),
            //busStop.name.toLowerCase().contains(query.toLowerCase()),
            clearOnSubmit: true,
          )),
    );
  }

  bool filter(BusStop busStop, String query) {
    List<String> keyWord = busStop.name.split(' ');
    keyWord.forEach((element) {
      if (element.toLowerCase().startsWith(query.toLowerCase())) {
        return true;
      }
    });
    return false;
  }

  Widget bottomButton() {
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
              print(token);
            },
            child: Icon(Icons.directions_bus),
            backgroundColor: Colors.lightBlueAccent,
          ),
          FloatingActionButton(
            heroTag: null,
            onPressed: () {
              //animateLocation(lat, long, 17);
            },
            child: Icon(Icons.my_location),
            backgroundColor: Colors.white70,
          ),
          FloatingActionButton(
            heroTag: null,
            onPressed: () {
              Navigator.pushNamed(context, '/user');
            },
            child: Icon(Icons.person),
            backgroundColor: Colors.lightBlueAccent,
          )
        ],
      ),
    );
  }
}
