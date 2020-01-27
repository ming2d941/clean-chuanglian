import 'package:clean_service/page/cart_page.dart';
import 'package:clean_service/page/home_page.dart';
import 'package:clean_service/page/mine_page.dart';
import 'package:clean_service/viewmodel/customer_controller.dart';
import 'package:flutter/material.dart';
import 'cart_model.dart';

import 'customer_info.dart';


class MainScreenModel extends ChangeNotifier {

  CustomerController customerController;

  CartModel _cartModel;

  int _currentTabIndex = 0;

  List<Widget> pages;

  MainScreenModel() {
    List<CustomerInfo> bigCustomer = List();
    bigCustomer.add(CustomerInfo()..id = 0..name = '外科楼'..nextInfo = (List<CustomerInfo>()
      ..add(CustomerInfo()..id = 0..name = '9病区')
      ..add(CustomerInfo()..id = 1..name = '8病区')
      ..add(CustomerInfo()..id = 2..name = '7病区')
      ..add(CustomerInfo()..id = 3..name = 'ICU')
      ..add(CustomerInfo()..id = 4..name = '六区')
      ..add(CustomerInfo()..id = 5..name = '手术室')
      ..add(CustomerInfo()..id = 6..name = '康复室')
    ));
    bigCustomer.add(CustomerInfo()..id = 1..name = '内科楼'..nextInfo = (List<CustomerInfo>()
      ..add(CustomerInfo()..id = 0..name = '1病区')
      ..add(CustomerInfo()..id = 1..name = '2病区')
      ..add(CustomerInfo()..id = 2..name = '3病区')
      ..add(CustomerInfo()..id = 3..name = '4病区')
      ..add(CustomerInfo()..id = 4..name = '5病区')
    ));

    bigCustomer.add(CustomerInfo()..id = 2..name = '急诊楼'..nextInfo = (List<CustomerInfo>()
      ..add(CustomerInfo()..id = 0..name = '1楼门诊')
      ..add(CustomerInfo()..id = 1..name = '1楼急诊')
      ..add(CustomerInfo()..id = 2..name = '内镜室')
      ..add(CustomerInfo()..id = 3..name = '11病区')
      ..add(CustomerInfo()..id = 4..name = '12病区')
      ..add(CustomerInfo()..id = 5..name = '13病区')
      ..add(CustomerInfo()..id = 6..name = '连廊')
    ));
    bigCustomer.add(CustomerInfo()..id = 3..name = '儿科/办公楼'..nextInfo = (List<CustomerInfo>()
      ..add(CustomerInfo()..id = 0..name = '儿科')
      ..add(CustomerInfo()..id = 1..name = '办公楼')
    ));

    pages = [HomePage(), CartPage(), MinePage()];

    customerController = CustomerController();
    customerController.allCustomer = List<Customer>()
      ..add(Personal()..info = (CustomerInfo()..id = 0..name = '个人'))
      ..add(BigCustomer()..info = (CustomerInfo()..id = 1..name = '脑科'..nextInfo = bigCustomer));

    _cartModel = CartModel();
  }

  setCustomerIndex(int index) {
    customerController?.index = index;
    notifyListeners();
  }

  addProduct(List<CustomerInfo> customerInfo, Product product) {
    customerInfo.forEach((customerInfo) {
      _cartModel.add(customerInfo, product);
    });
    notifyListeners();
  }

  setCurrentTab(int index) {
    if (_currentTabIndex == index) return;
    print('@@@ setCurrentTab $index');
    _currentTabIndex = index;

    notifyListeners();
  }

  int get currentTabIndex => _currentTabIndex;

  Widget get currentPage => pages[_currentTabIndex];

}