import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:web_hello_world/widget/custom_product_item.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _height;
  double _width;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[90],
      key: scaffoldKey,
      body: Container(
        height: _height,
        width: _width,
        child: Column(children: <Widget>[
          Center(
            child: Text("窗帘专业清洁"),
          ),
          _expandListView(),
        ]),
      ),
    );
  }

  _expandListView() {
    return Expanded(
      child: ExpandableTheme(
        data: ExpandableThemeData(iconColor: Colors.blue, useInkWell: false),
        child: ListView(
          children: <Widget>[
            CustomProductItem(),
            CustomProductItem(),
            CustomProductItem(),
            CustomProductItem(),
            CustomProductItem(),
            CustomProductItem(),
            CustomProductItem(),
            CustomProductItem(),
            CustomProductItem(),
          ],
        ),
      ),
    );
  }
}
