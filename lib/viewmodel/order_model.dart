import 'dart:io';

import 'package:clean_service/common/application.dart';
import 'package:clean_service/common/database_provider.dart';
import 'package:clean_service/common/db_to_model.dart';
import 'package:clean_service/page/order_list_page.dart';
import 'package:clean_service/viewmodel/cart_model.dart';
import 'package:clean_service/viewmodel/customer_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signature_view/flutter_signature_view.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class OrderModel extends ChangeNotifier {
  List<OrderInfo> allOrders;
  List<OrderInfo> prepareOrders;
  List<OrderInfo> doingOrders;
  List<OrderInfo> doneOrders;

  int currentPageIndex;

  OrderModel() {
    allOrders = List<OrderInfo>();
    prepareOrders = List<OrderInfo>();
    doingOrders = List<OrderInfo>();
    doneOrders = List<OrderInfo>();
  }

  Future<void> createOrder(
      Map<Customer, List<Product>> selectedCartInfoMap) async {
    if (selectedCartInfoMap == null || selectedCartInfoMap.isEmpty) {
      return;
    }

    var iterator = selectedCartInfoMap.keys.iterator;
    while (iterator.moveNext()) {
      Customer customer = iterator.current;
      if (customer != null) {
        OrderInfo orderInfo = OrderInfo()
          ..customer = customer
          ..products = selectedCartInfoMap[customer]
          ..startTime = currentTimeMillis();

        allOrders?.add(orderInfo);
        prepareOrders?.add(orderInfo);
        orderInfo.id = await DBProvider.db.insetOrder(orderInfo);
        orderInfo.buildBizId();
      }
    }
    allOrders.sort((a, b) => (b.startTime).compareTo(a.startTime));
    prepareOrders.sort((a, b) => (b.startTime).compareTo(a.startTime));
    notifyListeners();
  }

  updateOrder(OrderInfo order) async {
    final OrderStatus status = order.status;
    order.status = order.nextStatus();
    if (status == OrderStatus.prepare) {
      prepareOrders.removeWhere((element) => element.id == order.id);
      doingOrders.add(order);
    } else if (status == OrderStatus.doing) {
      doingOrders.removeWhere((element) => element.id == order.id);
      doneOrders.add(order);
    } else if (status == OrderStatus.done) {
      doneOrders.removeWhere((element) => element.id == order.id);
    }
    await DBProvider.db.updateOrderItem(order);
    sortAllArray();
    notifyListeners();
  }

  delOrder(OrderInfo order) async {
    allOrders.removeWhere((item) => order.id == item.id);
    prepareOrders.removeWhere((item) => order.id == item.id);
    doingOrders.removeWhere((item) => order.id == item.id);

    await DBProvider.db.delOrder(order.id);

    sortAllArray();
    notifyListeners();
  }

  Future<void> loadOrders(List<Customer> customers) async {
    prepareOrders.clear();
    doingOrders.clear();
    doneOrders.clear();

    allOrders = await DBProvider.db.getAllOrderInfo(customers);

    allOrders.forEach((element) {
      if (element.status == OrderStatus.prepare) {
        prepareOrders.add(element);
      } else if (element.status == OrderStatus.doing) {
        doingOrders.add(element);
      } else if (element.status == OrderStatus.done) {
        doneOrders.add(element);
      }
    });

    sortAllArray();
  }

  void setCurrentPage(int pageIndex) {
    print('@@@ setCurrentPage $pageIndex');
    currentPageIndex = pageIndex;
    notifyListeners();
  }

  List<OrderInfo> getData(int type) {
    print('@@@@ getData $type');
    List<OrderInfo> orders;
    OrderPageType pageType = OrderPageType.values[type];
    switch (pageType) {
      case OrderPageType.unRegister:
        orders = prepareOrders;
        break;
      case OrderPageType.doing:
        orders = doingOrders;
        break;
      case OrderPageType.done:
        orders = doneOrders;
        break;
      case OrderPageType.all:
        orders = allOrders;
        break;
    }
    return orders;
  }

  void sortAllArray() {
    allOrders.sort((a, b) => (b.startTime).compareTo(a.startTime));
    prepareOrders.sort((a, b) => (b.startTime).compareTo(a.startTime));
    doingOrders.sort((a, b) => (b.startTime).compareTo(a.startTime));
    doneOrders.sort((a, b) => (b.startTime).compareTo(a.startTime));
  }
}

class OrderDetail {
  final OrderInfo order;

  OrderPageType curPageType;

  OrderDetail(this.order, this.curPageType);

  mainButtonText() {
    String text;
    if (order.status == OrderStatus.prepare) {
      text = '登记';
    } else if (order.status == OrderStatus.doing) {
      text = '送回';
    } else if (order.status == OrderStatus.done) {
      text = '验收';
    } else {
      text = '好的';
    }
    return text;
  }

  customerName() {
    return order.customer.name;
  }

  startDate() {
    return formatDate(order.startTime);
  }

  isDoingStatus() {
    return order.status == OrderStatus.doing;
  }

  isDoneStatus() {
    return order.status == OrderStatus.done;
  }

  isRegisterStatus() {
    return order.status == OrderStatus.prepare;
  }

  isFinishedStatus() {
    return order.status == OrderStatus.finished;
  }

  subTile() {
    String text;
    if (isDoneStatus() || isFinishedStatus()) {
      text = '服务结算单';
    } else {
      text = '登记表';
    }
    return text;
  }

  saveOrder(OrderModel orderModel, SignatureView signatureView) async {
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      final dir = join(documentsDirectory.path, 'unregister_image');
      if (!await Directory(dir).exists()) {
        await Directory(dir).create(recursive: true);
      }
      final path = join(dir, '${order.startTime}_${order.id}.png');
      File file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
      await file.create();
      file.writeAsBytes(await signatureView?.exportBytes());
      order.signatureCustomer = file.path;
      if (isDoneStatus()) {
        order.endTime = currentTimeMillis();
      }
      print('@@@ ${order.signatureCustomer}');
    } catch (e) {
      print(e);
    }

    await orderModel.updateOrder(order);
  }

  String getBackDate() {
    if (isFinishedStatus()) {
      return "送回时间：${formatDate(order.endTime)}";
    }
    return "预计送回时间：${formatDate(order.startTime + Duration(days: 1).inMilliseconds)}";

  }

  hasServerSignature() {
    return order.signatureServer != null && order.signatureServer.isNotEmpty;
  }

  String getServerSignature() {
    return order.signatureServer;
  }

  saveServerSignature() async{
    String path = await Preference.getAdminSignPath();
    if (path != null && path.isNotEmpty) {
      order.signatureServer = path;
    }
  }

  bizId() {
    return order.bizId == null || order.bizId.isEmpty ? '' : 'No.${order.bizId}';
  }
}

class OrderInfo {
  int id;

  String bizId;

  Customer customer;

  List<Product> products;

  OrderStatus status = OrderStatus.prepare;

  num startTime = 0.0;

  num endTime = 0.0;

  int evaluateSpeed = 5;
  int evaluateQuality = 5;
  int evaluateConfig = 5;
  int evaluateMaintain = 5;
  int evaluateServer = 5;

  String signatureCustomer = '';
  String signatureServer = '';

  String orderImage = '';

  OrderStatus nextStatus() {
    var statusList = OrderStatus.values;
    int next = status.index + 1;
    return next >= statusList.length ? OrderStatus.finished : statusList[next];
  }

  String get productJson {
    if (products == null || products.isEmpty) {
      return null;
    }
    String json = '[';
    for (int i = 0; i < products.length; i++) {
      json += products[i].toJson();
      if (i != products.length - 1) {
        json += ',';
      }
    }
    json += ']';
    return json;
  }

  @override
  bool operator ==(Object other) {
    return other is OrderInfo &&
        other.id == this.id &&
        (other.customer == this.customer) &&
        (other.productJson == this.productJson) &&
        (other.startTime == this.startTime) &&
        (other.status == this.status);
  }

  @override
  int get hashCode => hashValues(id, customer, products, startTime);

  @override
  String toString() {
    return 'id: $id;customer: $customer;products: $productJson;status: ${status.toString()};startTime: $startTime;';
  }

  void buildBizId() {
    bizId = 'NK${formatBizNoByTime(startTime)}$id';
  }
}

enum OrderStatus { prepare, doing, done, finished }
