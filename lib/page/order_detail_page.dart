import 'dart:io';
import 'package:clean_service/common/application.dart';
import 'package:clean_service/config/ui_style.dart';
import 'package:clean_service/viewmodel/cart_model.dart';
import 'package:clean_service/viewmodel/order_model.dart';
import 'package:clean_service/widget/loading.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_signature_view/flutter_signature_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:typed_data';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import 'mine_page.dart' as MinePage;

class OrderDetailPage extends StatefulWidget {
  final OrderDetail orderDetail;

  const OrderDetailPage(this.orderDetail);

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  double _height;
  double _width;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var contentKey = GlobalKey<ScaffoldState>();
  bool isExpanded = false;

  SignatureView _signatureView;
  bool _isShowClear = true;
  ScreenshotController screenshotController = ScreenshotController();
  String _signatureData;

  @override
  void initState() {
    super.initState();
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

    print('@@@@ build ${widget.orderDetail.order.signatureCustomer}');
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
                    child: Container(
                      margin: EdgeInsets.only(top: 20),
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
                                "${widget.orderDetail.bizId()}",
                                style: AppTextStyle.order_no,
                              ),
                            ),
                            Text(
                              "聊城市脑科医院\n窗、围帘送洗${widget.orderDetail.subTile()}",
                              textAlign: TextAlign.center,
                              style: AppTextStyle.title,
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 25, 0, 5),
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "科室(病房)：${widget.orderDetail.customerName()}",
                                  )),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "送洗时间：${widget.orderDetail.startDate()}",
                                  )),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  child:
                                      Text(widget.orderDetail.getBackDate())),
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
                            ...widget.orderDetail.order.products
                                .map((e) => _productList(e))
                                .toList(),
                            _buildStartView(),
                            _buildSignView(),
                            _writeSignatureArea(),
                          ]),
                        ),
                      ),
                    ),
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
              },
            ),
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

  _buildStartView() {
    return widget.orderDetail.isDoneStatus() || widget.orderDetail.isFinishedStatus()
        ? Container(
            margin: EdgeInsets.fromLTRB(0, 25, 0, 2),
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '评价',
                    style: AppTextStyle.order_diver,
                  ),
                ),
                Divider(
                  height: 2,
                  color: Colors.grey,
                ),
                Container(margin: EdgeInsets.fromLTRB(0, 10, 0, 5)),
                ...widget.orderDetail.ratingItems
                    .map((e) => _buildRatingItem(e)),
              ],
            ),
          ) : Container();
  }

//洗涤质量情况
  //零配件配置情况
  //安装维护情况
  //服务人员服务质量
  Widget _buildRatingItem(RatingItem item) {
    print('@@@ _buildRatingItem ${item.current}');
    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Text(item.title),
          ),
          !widget.orderDetail.isFinishedStatus() ? Container(
            alignment: Alignment.centerLeft,
            child: RatingBar(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: item.onRatingUpdate,
            ),
          ) : Container(
            margin: EdgeInsets.only(left: 35, bottom: 5),
            alignment: Alignment.centerLeft,
            child: Text(item.ratingText()),),
        ],
      ),
    );
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
                    child: FutureBuilder(
                      future: _getServerSign(),
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? Column(
                                children: <Widget>[
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text('维保人员：')),
                                  Container(
                                    width: 200,
                                    height: 70,
                                    child: Image.file(File(snapshot.data)),
                                  ),
                                ],
                              )
                            : Container();
                      },
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Visibility(
                      visible: widget.orderDetail.isDoingStatus() ||
                          widget.orderDetail.isFinishedStatus(),
                      child: Column(
                        children: <Widget>[
                          Container(
                              alignment: Alignment.topLeft,
                              child: Text('科室负责人：')),
                          Container(
                              width: 200,
                              height: 70,
                              child: Image.file(File(
                                  widget.orderDetail.order.signatureCustomer))),
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
    String sign = await _getServerSign();
    if (sign == null || sign.isEmpty) {
      showServerSignature(ctx, () {
        widget.orderDetail.saveServerSignature();
        _innerSaveOrder(ctx);
      });
    } else {
      _innerSaveOrder(ctx);
    }
  }

  _onPressSure(BuildContext ctx) async {
    if (widget.orderDetail.isRegisterStatus() ||
        widget.orderDetail.isDoneStatus()) {
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
      showAlert(ctx, '您确定签名没问题了吗？', () {
        _saveOrder(ctx);
      });
    } else if (widget.orderDetail.isDoingStatus()) {
      showAlert(ctx, '您确定清洗完毕，需要送回吗？', () {
        _saveOrder(ctx);
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
                child: Text(widget.orderDetail.mainButtonText(),
                    style: AppTextStyle.text_regular_17),
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

  _writeSignatureArea() {
    return Visibility(
      visible: widget.orderDetail.isRegisterStatus() ||
          widget.orderDetail.isDoneStatus(),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                border: new Border.all(color: Colors.black38, width: 1),
              ),
              child: Stack(
                children: [
                  _signatureView,
                  GestureDetector(
                    child: Container(
                      alignment: Alignment.topRight,
                      padding: EdgeInsets.fromLTRB(15, 15, 15, 8),
                      child: Icon(
                        Icons.delete_sweep,
                        color: Colors.black38,
                      ),
                    ),
                    onTap: _clear,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  showServerSignature(BuildContext context, Function surePress) {
    print('@@@@ showAlert');
    MinePage.SimpleSignatureView signatureView = MinePage.SimpleSignatureView();
    showDialog(
        context: context,
        barrierDismissible: false,
        child: AlertDialog(
          title: Text('维保人员签名'),
          content: Container(
            height: 200,
            child: Column(
              children: <Widget>[
                signatureView,
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('确定'),
              onPressed: () {
                if (!signatureView.hasSign()) {
                  Fluttertoast.showToast(
                      msg: "请您灰色框内书写签名！",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIos: 1,
                      textColor: Colors.black);
                  return;
                }
                goSure(context, signatureView, surePress);
              },
            ),
          ],
        ));
  }

  void _innerSaveOrder(BuildContext ctx) async {
    showDialog<Null>(
        context: ctx,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new LoadingDialog(
            text: '正在保存订单..',
          );
        });
    await widget.orderDetail
        .saveOrder(Provider.of<OrderModel>(ctx), _signatureView);
    imageCache.clear();
    setState(() {});
    Navigator.pop(ctx);
  }

  void goSure(BuildContext context, MinePage.SimpleSignatureView signatureView,
      Function callback) async {
    await signatureView.saveSign();
    imageCache.clear();
    Navigator.of(context).pop();
    callback();
  }

  _getServerSign() async {
    String path = await Preference.getAdminSignPath();
    if (widget.orderDetail.hasServerSignature()) {
      return widget.orderDetail.getServerSignature();
    } else if (widget.orderDetail.isRegisterStatus() &&
        path != null &&
        path.isNotEmpty) {
      await widget.orderDetail.saveServerSignature();
      return widget.orderDetail.getServerSignature();
    } else {
      return null;
    }
  }
}
