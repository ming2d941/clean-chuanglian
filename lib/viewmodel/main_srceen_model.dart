import 'package:flutter/material.dart';

class MainScreenModel extends ChangeNotifier {

  int _currentTabIndex = 0;

  setCurrentTab(int index) {
    print('@@@ set image $index');
    _currentTabIndex = index;

    notifyListeners();
  }

  int get currentTabIndex => _currentTabIndex;


}