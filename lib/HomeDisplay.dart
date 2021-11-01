import 'package:flutter/material.dart';
import 'package:authentication/modelGet.dart';

class HomeDisplay extends StatelessWidget {
  final Data det;
  const HomeDisplay({Key key, @required this.det}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget displayData() {
      return Table(border: TableBorder.all(), children: [
        TableRow(children: <Widget>[
          Text("Serial number",
              style: TextStyle(color: Colors.grey, fontSize: 26)),
          Text("${det.col1}",
              style: TextStyle(color: Colors.black, fontSize: 26))
        ]),
        TableRow(children: <Widget>[
          Text("Product name",
              style: TextStyle(color: Colors.grey, fontSize: 26)),
          Text("${det.col2}",
              style: TextStyle(color: Colors.black, fontSize: 26))
        ]),
        TableRow(children: <Widget>[
          Text("Product description",
              style: TextStyle(color: Colors.grey, fontSize: 26)),
          Text("${det.col3}",
              style: TextStyle(color: Colors.black, fontSize: 26))
        ]),
        TableRow(children: <Widget>[
          Text("Country of Origin",
              style: TextStyle(color: Colors.grey, fontSize: 26)),
          Text("${det.col4}",
              style: TextStyle(color: Colors.black, fontSize: 26))
        ]),
        TableRow(children: <Widget>[
          Text("SKU", style: TextStyle(color: Colors.grey, fontSize: 26)),
          Text("${det.col5}",
              style: TextStyle(color: Colors.black, fontSize: 26))
        ])
      ]);
    }

    Widget checkFake() {
      return Container();
    }

    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: 350.0,
          floating: false,
          pinned: true,
          backgroundColor: Colors.blue,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: false,
            title: Text("Product Details"),
          ),
        ),
        SliverFillRemaining(
          child: Column(
            children: <Widget>[
              //   checkFake(),
              displayData(),
            ],
          ),
        )
      ],
    ));
  }
}
