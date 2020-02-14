import 'dart:convert';

import 'package:clean_service/config/constant.dart';
import 'package:clean_service/viewmodel/cart_model.dart';
import 'package:clean_service/viewmodel/customer_info.dart';
import 'package:clean_service/viewmodel/order_model.dart';
import 'package:flutter/cupertino.dart';

Map<String, dynamic> toCustomerMap(String name,
    {CustomerType type = CustomerType.bigCustomer, int parentId = -1}) {
  return {NAME: name, TYPE: type.index, PARENT_ID: parentId};
}

Map<String, dynamic> toProductMap(String name,
    {ProductType type = ProductType.ChuangLian, int count = 1}) {
  return {NAME: name, TYPE: type.index, COUNT: count};
}

Map<String, dynamic> toCustomerProductMap(int customerId, int productId) {
  return {CUSTOMER_ID: customerId, PRODUCT_ID: productId};
}

Map<String, dynamic> toCartMap(int customerId, int productId, int count) {
  return {
    CUSTOMER_ID: customerId,
    PRODUCT_ID: productId,
    COUNT: count,
    START_TIME: currentTimeMillis(),
    END_TIME: currentTimeMillis()
  };
}

Map<String, dynamic> toOrderMap(OrderInfo orderInfo) {
  return {
    CUSTOMER_ID: orderInfo.customer.id,
    PRODUCTS: orderInfo.productJson,
    ORDER_STATUS: orderInfo.status.index,
    START_TIME: orderInfo.startTime,
    END_TIME: orderInfo.endTime,
    SIGNATURE_PATH: orderInfo.signatureImage,
    ORDER_IMAGE_PATH: orderInfo.orderImage,
  };
}

int currentTimeMillis() {
  return new DateTime.now().millisecondsSinceEpoch;
}

List<Product> toProductList(String productJson) {
  List<Product> list = List<Product>();

  List<dynamic> jsonArray = json.decode(productJson);
  jsonArray.forEach((element) {
    list.add(Product.fromJsonMap(element));
  });
  
  return list;
}

formatDate(num time) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(time.toInt());
  String timestamp = "${date.year.toString()}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  return timestamp;
}

