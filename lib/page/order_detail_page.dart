import 'package:clean_service/common/db_to_model.dart';
import 'package:clean_service/config/provider_config.dart';
import 'package:clean_service/config/ui_style.dart';
import 'package:clean_service/viewmodel/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signature_view/flutter_signature_view.dart';

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
  bool isExpanded = false;

  GlobalKey<State<StatefulWidget>> _globalKey;
  SignatureView _signatureView;
  bool _isShowClear = true;

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
                padding: EdgeInsets.all(20),
                child: Column(children: <Widget>[
                  Text(
                    "聊城市脑科医院\n窗、围帘送洗登记表",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.title,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 15, 20, 20),
                    alignment: Alignment.centerRight,
                    child: Text(
                      "编号：${widget.order.id}",
                      style: AppTextStyle.order_no,
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
                          flex: 5,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text('清洗物品',
                              style: AppTextStyle.order_diver,),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text('数量',
                              style: AppTextStyle.order_diver,),
                          ),
                        ),
                    ],)),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Divider(height: 2, color: Colors.grey,),),

                  Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 5,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text('窗帘',),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text('3',),
                            ),
                          ),
                        ],)),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 8),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text('签字',
                        style: AppTextStyle.order_diver,),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Divider(height: 2, color: Colors.grey,),),

                  SizedBox(
                    width: _width,
                    height: _height / 3,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      decoration: new BoxDecoration(
                        border: new Border.all(color: Colors.black38, width: 1),
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
                                margin: EdgeInsets.fromLTRB(0, 15, 0, 8),
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
          ],
        ),
      ),
    );
  }

  void _clear() {
    _signatureView.clear();
  }

}