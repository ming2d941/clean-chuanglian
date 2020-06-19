import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:get_ip/get_ip.dart';
import 'package:sqflite/sqflite.dart';

class HttpSever {

  HttpSever();

  bind() async {

    String ipAddress = await GetIp.ipAddress;
    print('Listening on xxxx:${ipAddress}');
    print('Listening on localhost:${InternetAddress.loopbackIPv4}');
//    print('Listening on ip:${ipAddress}');

    var server = await HttpServer.bind(
      ipAddress,
      3000,
    );

    await for (HttpRequest request in server) {
      String _content = await loadLocal(request.uri.path);
//      body.request.response.statusCode = 200;
//      body.request.response.headers.set("Content-Type", "text/html; charset=utf-8");
//      body.request.response.write(_content);
//      body.request.response.close();

//      print('Listening on xxxx1:${_content}');
//      print('Listening on xxxx1:${request.uri}');
//      print('Listening on xxxx2:${request.requestedUri}');



//      var response = await http.get('https://www.baidu.com/');
//      //If the http request is successful the statusCode will be 200
//      if(response.statusCode == 200){
//        String htmlToParse = response.body;
//        print(htmlToParse);
//      }




      request.response
      ..statusCode = 200
      ..headers.set("Content-Type", '${detectMimeType(request.uri)}; charset=utf-8')
        ..contentLength = utf8.encode(_content).length
        ..write(_content)
        ..close();
    }
  }

  String detectMimeType(Uri uri) {
    print('Listening on xxxx3:${uri}');
//    print('Listening on xxxx4:${uri.path}');
    var fileName = uri.toString();
    if (fileName.endsWith(".html") || fileName.endsWith("/")) {
      return "text/html";
    } else if (fileName.endsWith(".js")) {
      return "application/javascript";
    } else if (fileName.endsWith(".css")) {
      return "text/css";
    } else if (fileName.endsWith(".json")) {
      return "application/json";
    } else {
      return "application/octet-stream";
    }
  }

  void makeRequest() async {
    var response = await http.get('https://www.baidu.com/');
    //If the http request is successful the statusCode will be 200
    if (response.statusCode == 200) {
      String htmlToParse = response.body;
      print(htmlToParse);
    }
  }

  Future<String> loadLocal(String file) async {
    print('Listening on loadLocal:${file}');
    if (file.endsWith('/')) {
      return await rootBundle.loadString('assets/htmls/index.html');
    } else if (file.contains('.')) {
      return await rootBundle.loadString('assets/htmls' + file);
    } else {
      var path = await getDatabasesPath();
      print('Listening on ----->>>>:${path}');
      var dir = new Directory(path);
      List contents = dir.listSync(recursive: true);
      for (var fileOrDir in contents) {
        if (fileOrDir is File) {
          print('Listening on ----->>>>file:${fileOrDir.path}');
          if (fileOrDir.path.endsWith('.db')) {
            var db = await openDatabase(fileOrDir.path);
//            Cursor c = database.rawQuery("SELECT name FROM sqlite_master WHERE type='table' OR type='view' ORDER BY name COLLATE NOCASE", null);
            final cursor = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' OR type='view' ORDER BY name COLLATE NOCASE");
            var iterator = cursor.iterator;
            while (cursor.isNotEmpty && iterator.moveNext()) {
              var item = iterator.current;
              if (item != null) {
                print('Listening on ----->>>>file:${item}');
              }
            }
          }

        } else if (fileOrDir is Directory) {
          print(fileOrDir.path);
          print('Listening on ----->>>>dir:${fileOrDir.path}');
        }
      }
    }
  }

}