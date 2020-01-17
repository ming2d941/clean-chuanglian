import 'package:flutter/material.dart';

class MinePage extends StatefulWidget {
  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  static List imgList = [
    'https://gcaeco.vn/static/media/images/shop/2018_11_09/319501224421579295553582717161942568402944n-1541774030.jpg',
    'https://image3.tienphong.vn/665x449/Uploaded/2019/uqvppivp/2016_04_28/rauantoan_rjoj.jpg',
    'https://media.ex-cdn.com/EXP/media.phunutoday.vn/files/news/2017/09/18/thuc-don-danh-cho-nguoi-bi-viem-da-di-ung-014122.jpg'
  ];
  double _height;
  double _width;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool isExpanded = false;

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
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            SizedBox(
              width: _width,
              height: _height / 6,
              child: Container(
                decoration: BoxDecoration(color: Color(0x2200ff00)),
                alignment: Alignment.centerLeft,
                child: Text('未确认订单'),
              ),
            ),
            SizedBox(
              width: _width,
              height: _height / 6,
              child: Container(
                decoration: BoxDecoration(color: Color(0x22ff0000)),
                alignment: Alignment.centerLeft,
                child: Text('全部订单'),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
