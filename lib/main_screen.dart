import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:web_hello_world/viewmodel/main_srceen_model.dart';

import 'cart_page.dart';
import 'home_page.dart';
import 'mine_page.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  List<Widget> pages;
  double iconSize = 20;

  @override
  void initState() {
    super.initState();
    pages = [HomePage(), CartPage(), MinePage()];
  }

  @override
  Widget build(BuildContext context) {
    print("@------> build ");
    return Consumer<MainScreenModel>(
        builder: (context, mainScreenModel, child) {
          return Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              iconSize: 20,
              selectedFontSize: 12,
              unselectedFontSize: 10,
              onTap: (int index) {
                mainScreenModel.setCurrentTab(index);
              },
              currentIndex: mainScreenModel.currentTabIndex,
              type: BottomNavigationBarType.fixed,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  title: Text('Home'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shop),
//            activeIcon: Icon(Icons.shopp),
                  title: Text('Cart'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesome.user_o),
                  activeIcon: Icon(FontAwesome.user),

                  title: Text('Mine'),
                ),
              ],
            ),
            body: pages[mainScreenModel.currentTabIndex],
          );
        });
  }
}

class WillPopScopeTestRoute extends StatefulWidget {
  @override
  WillPopScopeTestRouteState createState() {
    return new WillPopScopeTestRouteState();
  }
}

class WillPopScopeTestRouteState extends State<WillPopScopeTestRoute> {
  DateTime _lastPressedAt; //上次点击时间

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async {
          if (_lastPressedAt == null ||
              DateTime.now().difference(_lastPressedAt) > Duration(seconds: 1)) {
            //两次点击间隔超过1秒则重新计时
            _lastPressedAt = DateTime.now();
            return false;
          }
          return true;
        },
        child: Container(
          alignment: Alignment.center,
          child: Text("1秒内连续按两次返回键退出"),
        )
    );
  }
}