import 'package:clean_service/page/cart_page.dart';
import 'package:clean_service/page/home_page.dart';
import 'package:clean_service/page/mine_page.dart';
import 'package:clean_service/viewmodel/customer_controller.dart';
import 'package:clean_service/viewmodel/product_controller.dart';
import 'package:flutter/material.dart';


class MainScreenModel extends ChangeNotifier {
  CustomerController customerController;

  ProductController productController;

  int _currentTabIndex = 0;

  List<Widget> pages;

  MainScreenModel() {
    pages = [HomePage(), CartPage(), MinePage()];

    customerController = CustomerController();
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
