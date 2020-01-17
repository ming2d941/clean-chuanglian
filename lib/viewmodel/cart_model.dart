import 'package:flutter/material.dart';

class CartModel extends ChangeNotifier{
  List<Product> lists;

  CartModel() {
    lists = List<Product>();
  }

  add(Product product) {
    lists.add(product);

    notifyListeners();
  }

  remove(Product product) {
    lists.remove(product);

    notifyListeners();
  }

  modify(Product product) {
    if (lists.contains(product)) {
      lists.remove(product);
      lists.add(product);
      notifyListeners();
    }
  }
}

class Product {

  int width;
  int height;
  int price;

}