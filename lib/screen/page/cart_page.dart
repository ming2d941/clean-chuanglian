import 'package:flutter/material.dart';
import 'package:web_hello_world/config/provider_config.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  static List imgList = [
    'https://gcaeco.vn/static/media/images/shop/2018_11_09/319501224421579295553582717161942568402944n-1541774030.jpg',
    'https://image3.tienphong.vn/665x449/Uploaded/2019/uqvppivp/2016_04_28/rauantoan_rjoj.jpg',
    'https://media.ex-cdn.com/EXP/media.phunutoday.vn/files/news/2017/09/18/thuc-don-danh-cho-nguoi-bi-viem-da-di-ung-014122.jpg'
  ];
  double _height;
  double _width;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool isExpanded = false;

  GlobalKey<State<StatefulWidget>> _globalKey;

  /// 已描绘的点
  List<Offset> _points = <Offset>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _globalKey = GlobalKey();
  }

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
        child: Column(
          children: <Widget>[
            Expanded(
                child: Scrollbar(
              child: SingleChildScrollView(
                child: Column(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("工单"),
                  ),
                  // Padding widget
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                    child: Container(
                      alignment: Alignment.topLeft,
                      child:
                          new Text(ProviderConfig.getInstance().content(null)),
                    ),
                  ),
                ]),
              ),
            )),
            Container(
              margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
              alignment: Alignment.topLeft,
              child: Text(
                '确认无误，请您签字：',
              ),
            ),
            RepaintBoundary(
              key: _globalKey,
              child: SizedBox(
                width: _width,
                height: _height / 3,
                child: Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  decoration: new BoxDecoration(
                    border: new Border.all(color: Color(0x99FF0000), width: 1),
                  ),
                  child: Stack(
                    children: [
                      GestureDetector(
                        onPanUpdate: (details) => _addPoint(details),
                        onPanEnd: (details) => _points.add(null),
                      ),
                      CustomPaint(painter: BoardPainter(_points)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _addPoint(DragUpdateDetails details) {
    RenderBox referenceBox = _globalKey.currentContext.findRenderObject();
    Offset localPosition = referenceBox.globalToLocal(details.globalPosition);
    double maxW = referenceBox.size.width;
    double maxH = referenceBox.size.height;
    print('@@@ $localPosition');
    // 校验范围
    if (localPosition.dx <= 0 || localPosition.dy <= 0) return;
    if (localPosition.dx > maxW || localPosition.dy > maxH) return;
    setState(() {
      _points = List.from(_points)..add(localPosition);
    });
  }
}

class BoardPainter extends CustomPainter {
  BoardPainter(this.points);

  final List<Offset> points;

  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  bool shouldRepaint(BoardPainter other) => other.points != points;
}
