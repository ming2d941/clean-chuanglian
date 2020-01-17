import 'package:flutter/material.dart';
import 'package:web_hello_world/config/provider_config.dart';
import 'package:web_hello_world/screen/page/expanedable_test.dart';
import 'package:web_hello_world/screen/page/mine_page.dart';
import 'package:web_hello_world/viewmodel/cart_model.dart';

import '../screen/page/cart_page.dart';
import '../screen/page/home_page.dart';

class MainScreenModel extends ChangeNotifier {

  CartModel _cartModel;

  int _currentTabIndex = 0;

  List<Widget> pages;

  MainScreenModel() {
    pages = [HomePage(), CartPage(), MinePage()];
  }

  addProduct(Product product) {
    _cartModel.add(product);

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