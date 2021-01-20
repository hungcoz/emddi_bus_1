import 'package:emddi_bus/constants/constant.dart';
import 'package:emddi_bus/pages/bus/bus_stop.dart';
import 'package:emddi_bus/pages/map/ggmap.dart';
import 'package:flutter/material.dart';

class SearchBox extends StatefulWidget {
  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  bool _isSearching = false;

  List<BusStop> listBusStop = [];

  TextEditingController searchController = TextEditingController();

  Widget listResult() {
    return ListView.builder(
      itemCount: listBusStop.length,
      itemBuilder: (context, index) => buildBusStopCard(context, index),
      shrinkWrap: true,
    );
  }

  Widget buildBusStopCard(BuildContext context, int index) {
    BusStop busStop = listBusStop[index];
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: ListTile(
        onTap: () {
          animateLocation(busStop.latitude, busStop.longitude, 16);
          _isSearching = false;
          setState(() {
            searchController.text = busStop.name;
            searchController.selection = TextSelection.fromPosition(
                TextPosition(offset: searchController.text.length));
          });
        },
        title: Text(
          '${busStop.name}',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
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
        child: Stack(children: [
          TextField(
            style: TextStyle(fontSize: 18),
            controller: searchController,
            //focusNode: FocusNode(),
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              hintText: 'Tìm kiếm điểm dừng...',
              hintStyle: TextStyle(fontSize: 18),
              suffixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              _isSearching = true;
              search(value);
            },
            onSubmitted: (value) {
              _isSearching = false;
            },
          ),
          //SizedBox(height: 5,)],
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(
              top: 10,
              //right: 0.0,
              //left: 38.0
            ),
            child: _isSearching ? listResult() : null,
          )
        ]),
      ),
    );
  }
}
