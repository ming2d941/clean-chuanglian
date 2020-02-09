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
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            '订单管理',
            style: TextStyle(color: Colors.white),
          ),
          bottom: TabBar(
            tabs: _tabValues.map((item) {
              return Text(
                item['title'],
                style: TextStyle(fontSize: 18.0),
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
            labelStyle: TextStyle(height: 4.0),
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
                child: _buildList(orderModel,
                    orderModel.getData(int.parse(item['route']))),
              );
            }).toList(),
          );
        }));
  }

  void _onTabSelect(int index) {}

  _buildList(OrderModel orderModel, List<OrderInfo> list) {
    return ListView.separated(
      shrinkWrap: true,
      //physics: NeverScrollableScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
        OrderInfo _current = list[index];
        return Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: ListTile(
            onTap: () {
              ProviderConfig.getInstance().goOrderDetail(context, _current);
            },
            title: _current.customer.defaultTitleRow(),//new flag
            subtitle: Text(formatDate(_current.startTime)),
            trailing: GestureDetector(
              onTap: () {
                orderModel.delOrder(_current);
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
}

enum OrderPageType { unRegister, doing, done, all }
