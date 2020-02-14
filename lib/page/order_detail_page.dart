import 'dart:io';
import 'package:clean_service/common/db_to_model.dart';
import 'package:clean_service/config/ui_style.dart';
import 'package:clean_service/viewmodel/cart_model.dart';
import 'package:clean_service/viewmodel/order_model.dart';
import 'package:clean_service/widget/loading.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_signature_view/flutter_signature_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import 'order_list_page.dart';

class OrderDetailPage extends StatefulWidget {
  final OrderInfo order;
  final OrderPageType curPageType;

  const OrderDetailPage(this.order, this.curPageType);

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
  bool _hadSigned = false;
  String _mianBtnText;
  ScreenshotController screenshotController = ScreenshotController();
  String _signatureData;

  @override
  void initState() {
    super.initState();
    _globalKey = GlobalKey();
    _mianBtnText = _mainButtonText();
    _hadSigned = hasSignedInfo();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    _signatureView = SignatureView(
      backgroundColor: Colors.grey[50],
      penStyle: Paint()
        ..color = Colors.black
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 5.0,
      onSigned: (data) {
        _signatureData = data;
      },
    );

    print('${widget.order.signatureImage}');
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      body: Container(
        height: _height,
        width: _width,
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(
                    child: Scrollbar(
                  child: SingleChildScrollView(
                    child: Container(margin: EdgeInsets.only(top: 20),
                    child: Screenshot(
                      controller: screenshotController,
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                        child: Column(children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
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
                            child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "科室(病房)：${widget.order.customer.name}",
                                )),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "送洗时间：${formatDate(widget.order.startTime)}",
                                )),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "预计送回时间：${formatDate(widget.order.startTime)}",
                                )),
                          ),
                          Container(
                              padding: EdgeInsets.fromLTRB(0, 25, 0, 5),
                              child: Row(
                                children: <Widget>[
                                  Flexible(
                                    flex: 7,
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '清洗物品',
                                        style: AppTextStyle.order_diver,
                                      ),
                                    ),
                                  ),
                                  Flexible(
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
                          _buildSignView(),
                          Visibility(
                            visible: !_hadSigned,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding:
                                  const EdgeInsets.fromLTRB(0, 40, 0, 0),
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
                                        widget.order.signatureImage.isEmpty
                                            ? _signatureView
                                            : Image.file(File(
                                            widget.order.signatureImage)),
                                        Visibility(
                                          //!_signatureView.isEmpty nullpoint exception
                                          //https://github.com/flutter/flutter/issues/22029
                                          visible: _isShowClear,
                                          child: GestureDetector(
                                            child: Container(
                                              alignment: Alignment.topRight,
                                              padding: EdgeInsets.fromLTRB(
                                                  15, 15, 15, 8),
                                              child: Icon(
                                                Icons.delete_sweep,
                                                color: Colors.black38,
                                              ),
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
                          ),
                        ]),
                      ),
                    ),),
                  ),
                )),
                _buildButtonRow(context),
              ],
            ),
            GestureDetector(
              child: Container(
                padding: EdgeInsets.only(left: 20, top: 35),
                child: Icon(Icons.arrow_back, color: Colors.grey, size: 35),
              ),
              onTap: () {
                Navigator.pop(context);
            },),
          ],
        ),
      ),
    );
  }

  void _clear() {
    _signatureView.clear();
    _signatureData = '';
  }

  _productList(Product product) {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 7,
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  product.name,
                ),
              ),
            ),
            Flexible(
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

  _buildSignView() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 25, 0, 5),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              '签字',
              style: AppTextStyle.order_diver,
            ),
          ),
          Divider(
            height: 2,
            color: Colors.grey,
          ),
          Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
              child: Row(
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Text('维保人员：')),
                        Image.file(File(widget.order.signatureImage))
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Visibility(
                      visible: _hadSigned,
                      child: Column(
                        children: <Widget>[
                          Container(
                              alignment: Alignment.centerLeft,
                              child: Text('科室负责人：')),
                          Image.file(File(widget.order.signatureImage))
                        ],
                      ),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  _mainButtonText() {
    String text;
    if (widget.curPageType == OrderPageType.unRegister) {
      text = '确定';
    } else if (widget.curPageType == OrderPageType.doing) {
      text = '完成';
    } else if (widget.curPageType == OrderPageType.done) {
      text = '确定';
    } else {
      text = '好的';
    }
    return text;
  }

  _sendOrder() async {
    screenshotController.capture().then((File image) async {
      Uint8List data = await image.readAsBytes();
      await Share.file('my order', 'order.png', data, 'image/png', text: '单据');
//      final result = await ImageGallerySaver.saveImage(data);
//      print('@@@ _capturePng $result');
    }).catchError((onError) {
      print(onError);
    });
  }

  _saveOrder(BuildContext ctx) async {
    showDialog<Null>(
        context: ctx,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new LoadingDialog(
            text: '正在保存订单..',
          );
        });
    print('@@@ hasSignedInfo ${hasSignedInfo()}');
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      final dir = join(documentsDirectory.path, 'unregister_image');
      if (!await Directory(dir).exists()) {
        await Directory(dir).create(recursive: true);
      }
      final path =
          join(dir, '${widget.order.startTime}_${widget.order.id}.png');
      File file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
      await file.create();
      file.writeAsBytes(await _signatureView?.exportBytes());
      widget.order.signatureImage = file.path;
      print('@@@ ${widget.order.signatureImage}');
    } catch (e) {
      print(e);
    }

    await Provider.of<OrderModel>(ctx).updateOrder(widget.order);
    setState(() {
      _hadSigned = true;
    });
    Navigator.pop(ctx);
  }

  _onPressSure(BuildContext ctx) async {
    if (widget.curPageType == OrderPageType.unRegister ||
        widget.curPageType == OrderPageType.done) {
      bool noSignData = _signatureData == null || _signatureData.isEmpty;
      if (noSignData) {
        Fluttertoast.showToast(
            msg: "请您签字",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white);
        return;
      }
      if (!_hadSigned) {
        showAlert(ctx, '您确定签名没问题了吗？', () {
          _saveOrder(ctx);
        });
      }
    } else if (widget.curPageType == OrderPageType.doing) {
      showAlert(ctx, '您确定要送回吗？', () {
        Navigator.pop(ctx);
      });
    } else {
      showAlert(ctx, '您确定要关闭此页面吗？', () {
        Navigator.pop(ctx);
      });
    }
  }

  showAlert(BuildContext context, String content, Function callback) {
    showDialog(
        context: context,
        child: AlertDialog(
          title: Text('提示'),
          content: Text(content),
          actions: <Widget>[
            new FlatButton(
              child: new Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text('确定'),
              onPressed: () {
                Navigator.of(context).pop();
                callback();
              },
            ),
          ],
        ));
  }

  _buildButtonRow(BuildContext context) {
    return Container(
      height: 66,
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Row(
        children: <Widget>[
          Flexible(
            child: GestureDetector(
              onTap: () {
                _onPressSure(context);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(30.0),
                        bottomLeft: const Radius.circular(30.0),
                        topRight: const Radius.circular(30.0),
                        bottomRight: const Radius.circular(30.0))),
                alignment: Alignment.center,
                child: Text(_mianBtnText, style: AppTextStyle.text_regular_17),
              ),
            ),
            flex: 4,
          ),
          Container(
            width: 20,
          ),
          Flexible(
            child: GestureDetector(
              onTap: () {
                _sendOrder();
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(30.0),
                        bottomLeft: const Radius.circular(30.0),
                        topRight: const Radius.circular(30.0),
                        bottomRight: const Radius.circular(30.0))),
                alignment: Alignment.center,
                child: Text('发送', style: AppTextStyle.text_regular_17),
              ),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  bool hasSignedInfo() {
    return widget.order.signatureImage != null &&
        widget.order.signatureImage.isNotEmpty;
  }
}
