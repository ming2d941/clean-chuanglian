import 'package:clean_service/config/provider_config.dart';
import 'package:clean_service/page/order_list_page.dart';
import 'package:consumer_picker/flutter_jd_address_selector.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class MinePage extends StatefulWidget {
  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {

  // 订单类型
  List<OrderModel> orderModelList = [
    new OrderModel(icon: Icons.credit_card, title: '待登记', route: OrderPageType.unRegister),
    new OrderModel(
        icon: Icons.account_balance_wallet, title: '进行中', route: OrderPageType.doing),
    new OrderModel(icon: Icons.card_travel, title: '待验收', route: OrderPageType.done),
    new OrderModel(icon: Icons.assignment, title: '全部订单', route: OrderPageType.all)
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
        icon: Icons.room,
        title: '添加客户',
        route: 'customer',
        color: Colors.red),
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

  static List imgList = [
    'https://gcaeco.vn/static/media/images/shop/2018_11_09/319501224421579295553582717161942568402944n-1541774030.jpg',
    'https://image3.tienphong.vn/665x449/Uploaded/2019/uqvppivp/2016_04_28/rauantoan_rjoj.jpg',
    'https://media.ex-cdn.com/EXP/media.phunutoday.vn/files/news/2017/09/18/thuc-don-danh-cho-nguoi-bi-viem-da-di-ung-014122.jpg'
  ];
  double _height;
  double _width;
  var scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      body: userIndexUI(),
    );
  }

  void _choiceAddressDialog() async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return JDAddressDialog(
              onSelected: (province, city, county) {
                var address = '$province-$city-$county';
                print('@@@@ ${address}');
                setState(() {});
              },
              title: '选择地址',
              selectedColor: Colors.red,
              unselectedColor: Colors.black);
        });
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
                      border:
                      Border(bottom: BorderSide(color: Colors.grey[300]))),
                ),
                Container(
                  margin:
                  EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: orderModelList.map((item) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ProviderConfig.getInstance().getOrderListPage(
                                      item.route)));
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
                      color: Colors.white,
                      border:
                      Border(bottom: BorderSide(color: Colors.grey[300]))),
                ),
              ]))),

      SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 1.0,
          crossAxisSpacing: 1.0,
          childAspectRatio: 1.3,
        ),
        delegate:
        SliverChildBuilderDelegate((BuildContext context, int index) {
          return Ink(
            child: InkWell(
              onTap: () {
                _onPress(index);
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

  void _onPress(int index) {
    switch(index) {
      case 0:

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