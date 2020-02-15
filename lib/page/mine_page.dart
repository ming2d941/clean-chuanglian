import 'dart:io';

import 'package:clean_service/common/application.dart';
import 'package:clean_service/config/provider_config.dart';
import 'package:clean_service/config/ui_style.dart';
import 'package:clean_service/page/order_list_page.dart';
import 'package:consumer_picker/flutter_jd_address_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signature_view/flutter_signature_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as pathUtil;
import 'package:path_provider/path_provider.dart';

class MinePage extends StatefulWidget {
  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  // 订单类型
  List<OrderModel> orderModelList = [
    new OrderModel(
        icon: Icons.credit_card, title: '待登记', route: OrderPageType.unRegister),
    new OrderModel(
        icon: Icons.account_balance_wallet,
        title: '进行中',
        route: OrderPageType.doing),
    new OrderModel(
        icon: Icons.card_travel, title: '待验收', route: OrderPageType.done),
    new OrderModel(
        icon: Icons.assignment, title: '全部订单', route: OrderPageType.all)
  ];

  List<ToolsList> tools = [
    new ToolsList(
        icon: Icons.people,
        title: '维保人员签名',
        route: 'sign',
        color: Colors.lightBlue),
    new ToolsList(
        icon: Icons.receipt,
        title: '添加商品',
        route: 'product',
        color: Colors.orange),
    new ToolsList(
        icon: Icons.room, title: '添加客户', route: 'customer', color: Colors.red),
    new ToolsList(
        icon: Icons.monetization_on,
        title: '优惠活动',
        route: 'discount',
        color: Colors.green),
    new ToolsList(
        icon: Icons.face,
        title: '意见反馈',
        route: 'feedback',
        color: Colors.redAccent),
    new ToolsList(
        icon: Icons.share,
        title: '分享APP',
        route: 'shareApp',
        color: Color.fromARGB(255, 64, 207, 160)),
  ];

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
      body: userIndexUI(),
    );
  }

  Widget userIndexUI() {
    return CustomScrollView(slivers: <Widget>[
      SliverAppBar(
        pinned: true,
        elevation: 0.0,
        title: Text(
          '我的',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          Align(
            child: Container(
              margin: EdgeInsets.only(right: 10.0),
              child: InkWell(
                onTap: () {
                  //go setting
                },
                child: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      SliverPadding(
          padding: const EdgeInsets.all(0.0),
          sliver: SliverList(
              delegate: SliverChildListDelegate(<Widget>[
            Container(
              child: Text('我的订单'),
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.only(bottom: 8.0),
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[300]))),
            ),
            Container(
              margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: orderModelList.map((item) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ProviderConfig.getInstance()
                                  .getOrderListPage(item.route)));
                    },
                    child: Column(
                      children: <Widget>[
                        Icon(item.icon),
                        Container(
                          height: 8.0,
                        ),
                        Text(item.title)
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            Container(
              height: 10.0,
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
            ),
            Container(
              child: Text('常用功能'),
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.only(bottom: 8.0),
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[300]))),
            ),
          ]))),
      SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 1.0,
          crossAxisSpacing: 1.0,
          childAspectRatio: 1.3,
        ),
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return Ink(
            child: InkWell(
              onTap: () {
                _onPress(context, index);
//                Application.router
//                    .navigateTo(context, "/${tools[index].route}");
              },
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      tools[index].icon,
                      size: 30.0,
                      color: tools[index].color,
                    ),
                    Container(
                      height: 10.0,
                    ),
                    Text(tools[index].title)
                  ],
                ),
              ),
            ),
          );
        }, childCount: tools.length),
      )
    ]);
  }

  void _onPress(BuildContext context, int index) {
    switch (index) {
      case 0:
        showAlert(context);
        break;
      default:
        Fluttertoast.showToast(
            msg: "建设中，敬请期待...",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            textColor: Colors.black);
        break;
    }
  }

  showAlert(BuildContext context) {
    print('@@@@ showAlert');
    SimpleSignatureView signatureView = SimpleSignatureView();
    showDialog(
        context: context,
        child: AlertDialog(
          title: Text('修改签名'),
          content: SizedBox(
            width: 400,
            height: 240,
            child: Column(
              children: <Widget>[
                Container(
                  width: 400,
                  height: 40,
                  alignment: Alignment.bottomRight,
                  child: FutureBuilder<String>(
                    future: Preference.getAdminSignPath(),
                    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                      return (snapshot.hasData)
                          ? Row(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '当前签名：',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                Image.file(File(snapshot.data))
                              ],
                            )
                          : Container(alignment: Alignment.centerLeft,
                        child: Text(
                          '开始您的签名吧！',
                          style: TextStyle(color: Colors.grey),
                        ),);
                    },
                  ),
                ),
                signatureView,
              ],
            ),
          ),
//          content: Text('11111'),
          actions: <Widget>[
            new FlatButton(
              child: new Text('取消'),
              onPressed: () {
                imageCache.clear();
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text('确定'),
              onPressed: () {
                if (!signatureView.hasSign()) {
                  Fluttertoast.showToast(
                      msg: "请在灰色框内书写签名！",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIos: 1,
                      textColor: Colors.black);
                  return;
                }
                signatureView.saveSign();
                imageCache.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        ));
  }
}

typedef AsyncValueGetter<String> = Future<String> Function();

class SimpleSignatureView extends StatefulWidget {

  _SimpleSignatureState state = _SimpleSignatureState();

  @override
  State<StatefulWidget> createState() {
    return state;
  }

  bool hasSign() {
    return state.hasData();
  }

  Future<void> saveSign() async {
    try {
      String path = await state.save();
      print('@@@@@saveSign $path');
      await Preference.setAdminSignPath(path);
    } catch (e) {}
  }
}

typedef CloseDialogCallback = Function(
  BuildContext context,
  String path,
);

class _SimpleSignatureState extends State<StatefulWidget> {
  SignatureView _signatureView;
  String _signatureData;
  bool _isVisiable = false;

  _SimpleSignatureState() {
    _signatureView = SignatureView(
      backgroundColor: Colors.grey[50],
      penStyle: Paint()
        ..color = Colors.black
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 4.0,
      onSigned: (data) {
        _signatureData = data;
      },
    );
  }

  save() async {
    setState(() {
      _isVisiable = true;
    });

    String signPath = '';
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      final dir = pathUtil.join(documentsDirectory.path, 'admin_image');
      if (!await Directory(dir).exists()) {
        await Directory(dir).create(recursive: true);
      }
      final path = pathUtil.join(dir, 'admin.png');
      File file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
      print('@@@ exist ${await file.exists()}');
      await file.create();
      await file.writeAsBytes(await _signatureView?.exportBytes());
      signPath = file.path;
    } catch (e) {
      print(e);
    }
    return signPath;
  }

  void _clear() {
    _signatureView.clear();
    _signatureData = '';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: 330,
          height: 180,
          alignment: Alignment.center,
          child: _signatureView,
        ),
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
        Visibility(
          visible: _isVisiable,
          child: Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),
          ),
        ),
      ],
    );
  }

  bool hasData() {
    return _signatureData != null && _signatureData.isNotEmpty;
  }
}

class ToolsList {
  String title;
  IconData icon;
  String route;
  Color color;

  ToolsList({this.title, this.icon, this.route, this.color});
}

// 订单类型model
class OrderModel {
  IconData icon;
  String title;
  OrderPageType route;

  OrderModel({this.title, this.icon, this.route});
}
