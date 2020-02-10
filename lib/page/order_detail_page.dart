import 'dart:io';
import 'package:clean_service/common/db_to_model.dart';
import 'package:clean_service/config/ui_style.dart';
import 'package:clean_service/viewmodel/cart_model.dart';
import 'package:clean_service/viewmodel/order_model.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_signature_view/flutter_signature_view.dart';
import 'dart:typed_data';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:screenshot/screenshot.dart';

class OrderDetailPage extends StatefulWidget {
  final OrderInfo order;
  const OrderDetailPage(this.order);

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  double _height;
  double _width;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var contentKey = GlobalKey<ScaffoldState>();
  bool isExpanded = false;

  GlobalKey<State<StatefulWidget>> _globalKey;
  SignatureView _signatureView;
  bool _isShowClear = true;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
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

//    List<Widget> list = list;

    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      body: Container(
        height: _height,
        width: _width,
        child: Column(
          children: <Widget>[
            Expanded(
                child: Scrollbar(
              child: SingleChildScrollView(
                child: Screenshot(
                  controller: screenshotController,
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                    child: Column(children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 15, 0, 5),
                        alignment: Alignment.centerRight,
                        child: Text(
                          "NO.${widget.order.id}",
                          style: AppTextStyle.order_no,
                        ),
                      ),
                      Text(
                        "聊城市脑科医院\n窗、围帘送洗登记表",
                        textAlign: TextAlign.center,
                        style: AppTextStyle.title,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 25, 0, 5),
                        child: Expanded(
                          child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "科室(病房)：${widget.order.customer.name}",
                              )),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: Expanded(
                          child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "送洗时间：${formatDate(widget.order.startTime)}",
                              )),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: Expanded(
                          child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "预计送回时间：${formatDate(widget.order.startTime)}",
                              )),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(0, 25, 0, 5),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 7,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '清洗物品',
                                    style: AppTextStyle.order_diver,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '数量',
                                    style: AppTextStyle.order_diver,
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Divider(
                          height: 2,
                          color: Colors.grey,
                        ),
                      ),
                      ...widget.order.products
                          .map((e) => _productList(e))
                          .toList(),
                      Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '科室负责人签字',
                            ),
                          ),
                          SizedBox(
                            width: _width,
                            height: _height / 3,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              decoration: new BoxDecoration(
                                border: new Border.all(
                                    color: Colors.black38, width: 1),
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
                                        padding:
                                            EdgeInsets.fromLTRB(15, 15, 15, 8),
                                        child: Text('clear'),
                                      ),
                                      onTap: _clear,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
                ),
              ),
            )),
            GestureDetector(
              onTap: () {
                _capturePng();
              },
              child: SizedBox(
                width: _width * 0.9,
                height: 60,
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                  decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(30.0),
                          bottomLeft: const Radius.circular(30.0),
                          topRight: const Radius.circular(30.0),
                          bottomRight: const Radius.circular(30.0))),
                  alignment: Alignment.center,
                  child: Text('确定', style: AppTextStyle.text_regular_15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _capturePng() async {
    screenshotController.capture().then((File image) async {
      Uint8List data = await image.readAsBytes();
      final result = await ImageGallerySaver.saveImage(data);

      await Share.file('esys image', 'esys.png', data, 'image/png',
          text: 'My optional text.');
      print('@@@ _capturePng $result');
    }).catchError((onError) {
      print('@@@@ ' + onError);
    });

//    return new Future.delayed(const Duration(milliseconds: 2000), () async {
//      final ByteData bytes = await rootBundle.load(result);
//    await Share.share('$result', subject: 'Look what I made!');
//    });
  }

  void _clear() {
    _signatureView.clear();
  }

  _productList(Product product) {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 7,
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  product.name,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${product.count}',
                ),
              ),
            ),
          ],
        ));
  }
}
