import 'package:clean_service/common/db_to_model.dart';
import 'package:clean_service/config/provider_config.dart';
import 'package:clean_service/viewmodel/order_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderListPage extends StatefulWidget {
  OrderPageType orderType;

  OrderListPage(this.orderType);

  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  TabController _controller;

  final List<Map<String, dynamic>> _tabValues = [
    {'title': '待登记', 'route': '${OrderPageType.unRegister.index}'},
    {'title': '进行中', 'route': '${OrderPageType.doing.index}'},
    {'title': '待验收', 'route': '${OrderPageType.done.index}'},
    {'title': '全部', 'route': '${OrderPageType.all.index}'},
  ];

  @override
  void initState() {
    super.initState();
    _onTabSelect(widget.orderType.index);

    _controller = TabController(
      length: _tabValues.length,
      initialIndex: widget.orderType.index,
      vsync: ScrollableState(),
    );
    _controller.addListener(() {
      _onTabSelect(_controller.index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(
            '订单管理',
            style: TextStyle(color: Colors.white),
          ),
          bottom: TabBar(
            tabs: _tabValues.map((item) {
              return Padding(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: Text(
                  item['title'],
                  style: TextStyle(fontSize: 18.0),
                ),
              );
            }).toList(),
            controller: _controller,
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey[200],
            indicatorWeight: 2.0,
            indicatorPadding: EdgeInsets.only(
              top: 5.0,
            ),
//            labelStyle: TextStyle(height: 4.0),
          ),
        ),
        body: Consumer<OrderModel>(builder: (context, orderModel, child) {
          return TabBarView(
            controller: _controller,
            children: _tabValues.map((item) {
              return Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: _buildList(orderModel, item,
                    orderModel.getData(int.parse(item['route']))),
              );
            }).toList(),
          );
        }));
  }

  void _onTabSelect(int index) {
    widget.orderType = OrderPageType.values[index];
  }

  _buildList(
      OrderModel orderModel, Map<String, dynamic> item, List<OrderInfo> list) {
    return list == null || list.isEmpty
        ? Align(
            alignment: Alignment.center,
            child: Text('没有${item['title']}的订单...'),
          )
        : ListView.separated(
            shrinkWrap: true,
            //physics: NeverScrollableScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              OrderInfo _current = list[index];
              return Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: ListTile(
                  onTap: () {
                    ProviderConfig.getInstance()
                        .goOrderDetail(context, _current, widget.orderType);
                  },
                  title: _current.customer.defaultTitleRow(), //new flag
                  subtitle: Text(formatDate(_current.startTime)),
                  trailing: GestureDetector(
                    onTap: () {
                      _onDeletePress(orderModel, _current);
                    },
                    child: Icon(
                      Icons.delete_outline,
                      color: Colors.black54,
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Divider(
                  height: 2.0,
                  color: Colors.blueGrey,
                ),
              );
            },
          );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDeletePress(OrderModel orderModel, OrderInfo current) async {

    showDialog(
        context: context,
        child: AlertDialog(
          title: Text('注意'),
          content: Text('确认要删除${formatDate(current.startTime)}开始的${current.customer.name}的订单吗？'),
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
                orderModel.delOrder(current);
                Navigator.of(context).pop();
              },
            ),
          ],
        ));
  }
}

enum OrderPageType { unRegister, doing, done, all }
