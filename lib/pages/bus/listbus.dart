import 'package:emddi_bus/constants/constant.dart';
import 'package:emddi_bus/network/bus_router.dart';
import 'package:flutter/material.dart';

class ListBus extends StatefulWidget {
  @override
  _ListBusState createState() => _ListBusState();
}

class _ListBusState extends State<ListBus> {
  List<BusRouter> listRouter = [];

  void chooseRoute(int index) {
    BusRouter instance = busRouters[index];
    Navigator.pushNamed(context, '/route_detail', arguments: instance);
  }

  @override
  void initState() {
    super.initState();
    listRouter.addAll(busRouters);
  }

  void filterRoute(String value) {
    if (value.isNotEmpty) {
      List<BusRouter> dummyData = <BusRouter>[];
      busRouters.forEach((element) {
        if (element.routerId.toString().contains(value) ||
            element.startPoint.toLowerCase().contains(value.toLowerCase()) ||
            element.endPoint.toLowerCase().contains(value.toLowerCase())) {
          dummyData.add(element);
        }
      });
      setState(() {
        listRouter.clear();
        listRouter.addAll(dummyData);
      });
      return;
    } else {
      setState(() {
        listRouter.clear();
        listRouter.addAll(busRouters);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Danh sách các tuyến Bus'),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
            child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(8, 10, 8, 5),
              child: TextField(
                onChanged: (value) {
                  filterRoute(value);
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(25, 10, 5, 5),
                  hintText: 'Tìm kiếm...',
                  hintStyle: TextStyle(
                    fontSize: 20,
                  ),
                  suffixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: listRouter.length,
                itemBuilder: (context, index) => buildBusCard(context, index),
                shrinkWrap: true,
              ),
            )
          ],
        )),
      ),
    );
  }

  Widget buildBusCard(BuildContext context, int index) {
    BusRouter busRouter = listRouter[index];
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
      child: Card(
        child: ListTile(
          onTap: () {
            chooseRoute(index);
          },
          title: Text('${busRouter.startPoint} - ${busRouter.endPoint}'),
          leading: CircleAvatar(
            child: Text('${busRouter.routerId}'),
          ),
          subtitle: Text('${busRouter.city}'),
        ),
      ),
    );
  }
}
