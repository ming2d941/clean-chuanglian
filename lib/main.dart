import 'package:appspector/appspector.dart';
import 'package:clean_service/page/splash_page.dart';
import 'package:clean_service/viewmodel/main_srceen_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  //TestWidgetsFlutterBinding.ensureInitialized();
//  runAppSpector();
  runApp(MyApp());
}

void runAppSpector() {
  var config = new Config();
//  config.iosApiKey = "Your iOS API_KEY";
//  config.androidApiKey = "android_MTY0NmFiY2UtYTVmZC00MWMzLWIwYjctM2JhNzBjYTc3ODg0";
  config.androidApiKey = "android_ZjE4M2E3ODYtMGFiMi00NjRjLWIwZDUtNTVjOTk2YjlhZTgy";
  AppSpectorPlugin.run(config);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '专业清洁服务',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashPage(),
      routes: {},
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("@------> build ");
    return Consumer<MainScreenModel>(
        builder: (context, mainScreenModel, child) {
      return SafeArea(
        child: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.grey[90],
            iconSize: 25,
            selectedFontSize: 12,
            unselectedFontSize: 10,
            onTap: (int index) {
              mainScreenModel.setCurrentTab(index);
            },
            currentIndex: mainScreenModel.currentTabIndex,
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(FontAwesome.home),
                title: Text('首页'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shop),
                title: Text('下单'),
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesome.user),
                title: Text('我的'),
              ),
            ],
          ),
          body: mainScreenModel.currentPage,
        ),
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
              DateTime.now().difference(_lastPressedAt) >
                  Duration(seconds: 1)) {
            //两次点击间隔超过1秒则重新计时
            _lastPressedAt = DateTime.now();
            return false;
          }
          return true;
        },
        child: Container(
          alignment: Alignment.center,
          child: Text("1秒内连续按两次返回键退出"),
        ));
  }
}
