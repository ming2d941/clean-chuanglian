import 'package:clean_service/page/cart_page.dart';
import 'package:clean_service/page/home_page.dart';
import 'package:clean_service/page/mine_page.dart';
import 'package:clean_service/viewmodel/customer_controller.dart';
import 'package:clean_service/viewmodel/product_controller.dart';
import 'package:flutter/material.dart';

import 'customer_info.dart';


class MainScreenModel extends ChangeNotifier {

  CustomerController customerController;

  ProductController productController;

  int _currentTabIndex = 0;

  List<Widget> pages;

  MainScreenModel() {
    Customer naoKe = Customer()..id = 0..name = '脑科'..type = CustomerType.bigCustomer;
    Customer personal = Customer()..id = 1..name = '个人'..type = CustomerType.personal;

    List<Customer> bigCustomer = List();
    Customer waiKe = Customer()..id = 0..name = '外科楼'..parent = naoKe;
    bigCustomer.add(
        waiKe..children = (List<Customer>()
      ..add(Customer()..id = 0..name = '9病区'..parent = waiKe)
      ..add(Customer()..id = 1..name = '8病区'..parent = waiKe)
      ..add(Customer()..id = 2..name = '7病区'..parent = waiKe)
      ..add(Customer()..id = 3..name = 'ICU'..parent = waiKe)
      ..add(Customer()..id = 4..name = '六区'..parent = waiKe)
      ..add(Customer()..id = 5..name = '手术室'..parent = waiKe)
      ..add(Customer()..id = 6..name = '康复室'..parent = waiKe)
    ));
    Customer neiKe = Customer()..id = 1..name = '内科楼'..parent = naoKe;
    bigCustomer.add(neiKe..children = (List<Customer>()
      ..add(Customer()..id = 0..name = '1病区'..parent = neiKe)
      ..add(Customer()..id = 1..name = '2病区'..parent = neiKe)
      ..add(Customer()..id = 2..name = '3病区'..parent = neiKe)
      ..add(Customer()..id = 3..name = '4病区'..parent = neiKe)
      ..add(Customer()..id = 4..name = '5病区'..parent = neiKe)
    ));
    Customer jiZhen = Customer()..id = 2..name = '急诊楼'..parent = naoKe;
    bigCustomer.add(jiZhen..children = (List<Customer>()
      ..add(Customer()..id = 0..name = '1楼门诊'..parent = jiZhen)
      ..add(Customer()..id = 1..name = '1楼急诊'..parent = jiZhen)
      ..add(Customer()..id = 2..name = '内镜室'..parent = jiZhen)
      ..add(Customer()..id = 3..name = '11病区'..parent = jiZhen)
      ..add(Customer()..id = 4..name = '12病区'..parent = jiZhen)
      ..add(Customer()..id = 5..name = '13病区'..parent = jiZhen)
      ..add(Customer()..id = 6..name = '连廊'..parent = jiZhen)
    ));
    Customer banGong = Customer()..id = 3..name = '儿科/办公楼'..parent = naoKe;
    bigCustomer.add(banGong..children = (List<Customer>()
      ..add(Customer()..id = 0..name = '儿科'..parent = banGong)
      ..add(Customer()..id = 1..name = '办公楼'..parent = banGong)
    ));

    pages = [HomePage(), CartPage(), MinePage()];

    customerController = CustomerController();
    customerController.allCustomer = List<Customer>()
      ..add(naoKe..children = bigCustomer)
      ..add(personal);

    productController = ProductController();
  }

  setCustomerIndex(int index) {
    customerController?.index = index;
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