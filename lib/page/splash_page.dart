import 'dart:async';

import 'package:clean_service/config/provider_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProviderConfig.getInstance().preloadDataController.preLoadData();
    Timer(Duration(seconds: 2),
      () {
        Navigator.of(context).pushReplacement(new MaterialPageRoute(
            builder: (BuildContext context) =>
                ProviderConfig.getInstance().getMainPage()));
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
