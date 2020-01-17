import 'dart:async';

import 'package:flutter/material.dart';

import 'config/provider_config.dart';

void main() => runApp(MyApp());

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

class SplashPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    Timer(Duration(seconds: 2),
          () {
            Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => ProviderConfig.getInstance().getMainPage()));
      },
    );
    return Scaffold(
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '因为用心，所以专业',
              style: Theme.of(context).textTheme.display1,
            ),
            Text(
              '窗帘清洗',
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


