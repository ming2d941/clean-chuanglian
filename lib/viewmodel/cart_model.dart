import 'package:flutter/material.dart';

import 'customer_info.dart';

class CartModel extends ChangeNotifier {
  Map<CustomerInfo, List<Product>> lists;

  CartModel() {
    lists = Map<CustomerInfo, List<Product>>();
  }

  add(CustomerInfo customerInfo, Product product) {
    if (lists.containsKey(customerInfo)) {
      lists[customerInfo]?.forEach((productItem) {
        if (product == productItem) {
          product.count++;
        } else {
          lists[customerInfo]?.add(product);
        }
      });
    } else {
      lists[customerInfo] = List<Product>()..add(product);
    }
    notifyListeners();
  }

  remove(CustomerInfo customerInfo, Product product) {
    if (lists.containsKey(customerInfo)) {
      lists[customerInfo]?.forEach((productItem) {
        if (product == productItem) {
          if (product.count > 1) {
            product.count--;
          } else {
            lists[customerInfo].remove(product);
          }
        }
      });
    }

    notifyListeners();
  }
}

class Product {
  int count = 1;

  int price;

  ProductType type;
}

enum ProductType {
  ChuangLian,
  WeiLian,
  Custom,
}
