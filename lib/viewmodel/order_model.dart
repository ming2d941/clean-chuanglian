import 'package:clean_service/common/database_provider.dart';
import 'package:clean_service/common/db_to_model.dart';
import 'package:clean_service/page/order_list_page.dart';
import 'package:clean_service/viewmodel/cart_model.dart';
import 'package:clean_service/viewmodel/customer_info.dart';
import 'package:flutter/material.dart';

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

  Future<void> createOrder(Map<Customer, List<Product>> selectedCartInfoMap) async {
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
      }
    }
    allOrders.sort((a, b) => (b.startTime).compareTo(a.startTime));
    prepareOrders.sort((a, b) => (b.startTime).compareTo(a.startTime));
    notifyListeners();
  }

  updateOrder(OrderInfo order) async {
    //TODO list
    await DBProvider.db.updateOrderItem(order);
    notifyListeners();
  }

  delOrder(OrderInfo order) async {
    allOrders.removeWhere((item)=> order == item);
    prepareOrders.removeWhere((item)=> order == item);
    doingOrders.removeWhere((item)=> order == item);

    await DBProvider.db.delOrder(order.id);
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

    allOrders.sort((a, b) => (b.startTime).compareTo(a.startTime));
    prepareOrders.sort((a, b) => (b.startTime).compareTo(a.startTime));
    doingOrders.sort((a, b) => (b.startTime).compareTo(a.startTime));
    doneOrders.sort((a, b) => (b.startTime).compareTo(a.startTime));
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
}

class OrderInfo {
  int id;

  Customer customer;

  List<Product> products;

  OrderStatus status = OrderStatus.prepare;

  num startTime = 0.0;

  num endTime = 0.0;

  String signatureImage = '';

  String orderImage = '';

  String get productJson {
    if (products == null || products.isEmpty){
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
  int get hashCode => hashValues(id, customer,products, startTime);

  @override
  String toString() {
    return 'id: $id;customer: $customer;products: $productJson;status: ${status.toString()};startTime: $startTime;';
  }
}

enum OrderStatus { prepare, doing, done }
