import 'package:emddi_bus/constants/constant.dart';
import 'package:emddi_bus/network/bus_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ListBus extends StatefulWidget {
  @override
  _ListBusState createState() => _ListBusState();
}

class _ListBusState extends State<ListBus> {
  List<BusRouter> routerHN = [];
  List<BusRouter> routerNT = [];
  List<BusRouter> routerHL = [];

  void chooseRoute(List listBus, int index) {
    BusRouter instance = listBus[index];
    Navigator.pushNamed(context, '/route_detail', arguments: instance);
  }

  @override
  void initState() {
    super.initState();
    filterRoute();
  }

  void filterRoute() {
    busRouters.forEach((element) {
      if (element.officeId == 1)
        routerHN.add(element);
      else if (element.officeId == 2)
        routerNT.add(element);
      else if (element.officeId == 3)
        routerHL.add(element);
      else {}
    });
  }

  void filterSearchResult(String value) {
    List<BusRouter> dummySearchHN = <BusRouter>[];
    List<BusRouter> dummySearchNT = <BusRouter>[];
    List<BusRouter> dummySearchHL = <BusRouter>[];
    dummySearchHN.addAll(routerHN);
    dummySearchNT.addAll(routerNT);
    dummySearchHL.addAll(routerHL);

    if (value.isNotEmpty) {
      List<BusRouter> dummyDataHN = <BusRouter>[];
      List<BusRouter> dummyDataNT = <BusRouter>[];
      List<BusRouter> dummyDataHL = <BusRouter>[];
      dummySearchHN.forEach((element) {
        if (element.routerId.toString().contains(value)) {
          dummyDataHN.add(element);
        }
      });
      dummySearchNT.forEach((element) {
        if (element.routerId.toString().contains(value)) {
          dummyDataNT.add(element);
        }
      });
      dummySearchHL.forEach((element) {
        if (element.routerId.toString().contains(value)) {
          dummyDataHL.add(element);
        }
      });
      setState(() {
        routerHN.clear();
        routerHN.addAll(dummyDataHN);

        routerNT.clear();
        routerNT.addAll(dummyDataNT);

        routerHL.clear();
        routerHL.addAll(dummyDataHL);
      });
      return;
    } else {
      setState(() {
        routerHN.clear();
        routerNT.clear();
        routerHL.clear();
        filterRoute();
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
                    filterSearchResult(value);
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(25, 10, 5, 5),
                    hintText: 'Tìm tuyến số...',
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
                child: CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Column(
                            children: [
                              buildListBus(routerHN),
                              buildListBus(routerNT),
                              buildListBus(routerHL),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildListBus(List listBus) {
    if (listBus.isNotEmpty) {
      return Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Text(
            '${listBus[0].city}',
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(
            height: 5,
          ),
          ListView.builder(
            itemBuilder: (context, index) =>
                buildBusCard(context, index, listBus),
            itemCount: listBus.length,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
          ),
        ],
      );
    }
    return SizedBox(
      height: 5,
    );
  }

  Widget buildBusCard(BuildContext context, int index, List listBus) {
    BusRouter busRouter = listBus[index];
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
      child: Card(
        child: ListTile(
          onTap: () {
            chooseRoute(listBus, index);
          },
          title: Text('${busRouter.startPoint} - ${busRouter.endPoint}'),
          leading: CircleAvatar(
            child: Text('${busRouter.routerId}'),
          ),
        ),
      ),
    );
  }
}
