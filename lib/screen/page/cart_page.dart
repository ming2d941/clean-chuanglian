import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:web_hello_world/config/provider_config.dart';
import 'package:flutter_signature_view/flutter_signature_view.dart';
import 'package:web_hello_world/config/ui_style.dart';

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
  SignatureView _signatureView;
  bool _isShowClear = true;

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

    _signatureView = SignatureView(
      backgroundColor: Colors.grey[100],
      penStyle: Paint()
        ..color = Colors.blue
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 5.0,
      onSigned: (data) {
        print("On change $data");
//        bool isVisible = data.isNotEmpty;
//        if (isVisible != _isShowClear) {
//          setState(() {
//            _isShowClear = isVisible;
//          });
//        }
      },
    );

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
                    child: Text("工单", style: AppTextStyle.title,),
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
                    child: Container(
                      alignment: Alignment.topLeft,
                      child:
                      new Text('确认无误，请您签字：'),
                    ),
                  ),
                  SizedBox(
                    width: _width,
                    height: _height / 3,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      decoration: new BoxDecoration(
                        border:
                            new Border.all(color: Colors.black38, width: 1),
                      ),
                      child: Stack(
                        children: [
                          _signatureView,
                          Visibility(
                            //!_signatureView.isEmpty nullpoint exception
                            //https://github.com/flutter/flutter/issues/22029
                            visible: _isShowClear,
                            child: GestureDetector(
                              child: Container(
                                alignment: Alignment.topRight,
                                margin: EdgeInsets.fromLTRB(8, 15, 15, 8),
                                child: Text('clear'),
                              ),
                              onTap: _clear,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            )),
            SizedBox(
              width: _width * 0.9,
              height: 60,
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                decoration: BoxDecoration(color: Colors.greenAccent,
                    borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(30.0),
                    bottomLeft: const Radius.circular(30.0),
                    topRight: const Radius.circular(30.0),
                    bottomRight: const Radius.circular(30.0))),

                alignment: Alignment.center,
                child: Text('确定',style: AppTextStyle.text_regular_15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _clear() {
    _signatureView.clear();
  }
}

class SignatureView1 extends SignatureView {

  SignatureView1({
    backgroundColor = Colors.white,
    data,
    penStyle,
    onSigned,
  });

  @override
  bool get isEmpty => key == null || key.currentState == null ? true : super.isEmpty;
}
