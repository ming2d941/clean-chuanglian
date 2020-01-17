import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_hello_world/viewmodel/main_srceen_model.dart';

import '../main_screen.dart';

class ProviderConfig {
  static ProviderConfig _instance;

  static ProviderConfig getInstance() {
    if (_instance == null) {
      _instance = ProviderConfig._internal();
    }
    return _instance;
  }

  ProviderConfig._internal();


  ///主页provider
  ChangeNotifierProvider<MainScreenModel> getMainPage() {
    return ChangeNotifierProvider.value(value: MainScreenModel(),
        child: MainScreen(),);
  }
//
//  ///任务详情页provider
//  ChangeNotifierProvider<TaskDetailPageModel> getTaskDetailPage(
//      int index,
//      TaskBean taskBean, {
//        DoneTaskPageModel doneTaskPageModel,
//        SearchPageModel searchPageModel,
//      }) {
//    return ChangeNotifierProvider<TaskDetailPageModel>(
//      builder: (context) => TaskDetailPageModel(
//        taskBean,
//        doneTaskPageModel: doneTaskPageModel,
//        searchPageModel: searchPageModel,
//        heroTag: index,
//      ),
//      child: TaskDetailPage(),
//    );
//  }
}
