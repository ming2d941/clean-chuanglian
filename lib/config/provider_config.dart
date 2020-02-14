import 'package:clean_service/page/order_detail_page.dart';
import 'package:clean_service/page/order_list_page.dart';
import 'package:clean_service/viewmodel/cart_model.dart';
import 'package:clean_service/viewmodel/order_model.dart';
import 'package:clean_service/viewmodel/preload_all_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class ProviderConfig {
  static ProviderConfig _instance;
  PreloadDataController preloadDataController;

  static ProviderConfig getInstance() {
    if (_instance == null) {
      _instance = ProviderConfig._internal();
    }
    return _instance;
  }

  ProviderConfig._internal() {
    preloadDataController = PreloadDataController();
  }


  Widget getMainPage() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: preloadDataController.mainScreenModel,
        ),
        ChangeNotifierProvider.value(
          value: preloadDataController.cartModel,
        ),
        ChangeNotifierProvider.value(
          value: preloadDataController.orderModel,
        ),
      ],
      child: MainScreen(),
    );
  }

  Widget getOrderListPage(OrderPageType type) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: preloadDataController.orderModel,
        ),
      ],
      child: OrderListPage(type),
    );
  }

  Widget getOrderDetailPage(OrderInfo order, OrderPageType curPageType) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: preloadDataController.orderModel,
        ),
      ],
      child: OrderDetailPage(order, curPageType),
    );
  }

  goOrderList(BuildContext context, OrderPageType type) {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => getOrderListPage(type)));
  }

  goOrderDetail(BuildContext context, OrderInfo order, OrderPageType curPageType) {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => getOrderDetailPage(order, curPageType)));
  }

  String content(CartModel cartModel) {
    return "xxx 先生/女士，您好：\n请您确认要清洗的商品如下：\n\n\t1.101室窗帘\n\t\t规格：180cmx40cm\n\t\t材质：化纤\n\t\t价格：￥100\n\n\t2.306室窗帘\n\t\t规格：180cmx40cm\n\t\t材质：化纤\n\t\t价格：￥100\n\n\t3.806室窗帘\n\t\t规格：190cmx40cm\n\t\t材质：棉\n\t\t价格：￥150\n\n\t4.1806室窗帘\n\t\t规格：200cmx50cm\n\t\t材质：棉\n\t\t价格：￥180\n\n";
  }
//
//  ///任务详情页provider
//  ChangeNotifierProvider<TaskDetailPageModel> getTaskDetailPage(
//      int index,
//      TaskBean taskBean, {
//        DoneTaskPageModel doneTaskPageModel,
//        SearchPageModel searchPageModel,
//      }) {
//    return ChangeNotifierProvider<TaskDetailPageModel>(
//      builder: (context) => TaskDetailPageModel(
//        taskBean,
//        doneTaskPageModel: doneTaskPageModel,
//        searchPageModel: searchPageModel,
//        heroTag: index,
//      ),
//      child: TaskDetailPage(),
//    );
//  }
}
