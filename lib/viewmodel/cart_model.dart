import 'dart:convert';

import 'package:clean_service/common/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'customer_info.dart';

class CartModel extends ChangeNotifier {
  Map<Customer, List<Product>> allCartInfoMap;
  Map<Customer, List<Product>> selectedCartInfoMap;
  bool _isAllSelected = false;
  Function _listEquals;

  CartModel() {
    _listEquals = const ListEquality().equals;
    allCartInfoMap = Map<Customer, List<Product>>();
    selectedCartInfoMap = Map<Customer, List<Product>>();
  }

  isSelectCustomer(Customer customer) {
    return allCartInfoMap != null &&
        selectedCartInfoMap.containsKey(customer) &&
        _listEquals(selectedCartInfoMap[customer], allCartInfoMap[customer]);
  }

  selectAllProductOfCustomer(Customer customerInfo) {
    if (allCartInfoMap == null) {
      return;
    }

    bool isCurSelected = isSelectCustomer(customerInfo);

    selectedCartInfoMap.remove(customerInfo);
    if (!isCurSelected) {
      selectedCartInfoMap[customerInfo] = List<Product>();
      allCartInfoMap[customerInfo].forEach((product) {
        selectedCartInfoMap[customerInfo].add(product);
      });
    } else {
      allCartInfoMap[customerInfo].forEach((product) {});
    }
    checkAllSelected();
    notifyListeners();
  }

  void selectProduct(Customer customer, Product product) {
    if (allCartInfoMap == null) {
      return;
    }
    bool isProductSelected = isSelect(customer, product);
    if (isProductSelected) {
      selectedCartInfoMap[customer]
          .removeWhere((element) => product == element);
      if (selectedCartInfoMap[customer].length == 0) {
        selectedCartInfoMap.remove(customer);
      }
    } else {
      _select(customer, product);
    }
    checkAllSelected();
    notifyListeners();
  }

  checkAllSelected() {
    return _isAllSelected = allCartInfoMap != null &&
        MapEquality(values: ListEquality())
            .equals(selectedCartInfoMap, allCartInfoMap);
  }

  isSelect(Customer customer, Product product) {
    return selectedCartInfoMap.containsKey(customer) &&
        selectedCartInfoMap[customer].contains(product);
  }

  _select(Customer customerInfo, Product product) {
    if (selectedCartInfoMap.containsKey(customerInfo)) {
      List<Product> products = selectedCartInfoMap[customerInfo];
      if (products == null) {
        products = List<Product>();
        selectedCartInfoMap[customerInfo] = products;
      }
      if (!products.contains(product)) {
        products.add(product);
      }
    } else {
      selectedCartInfoMap[customerInfo] = List<Product>()..add(product);
    }
  }

  _selectAll() {
    if (allCartInfoMap == null) {
      return;
    }
    selectedCartInfoMap.clear();

    allCartInfoMap.forEach((customer, products) {
      selectedCartInfoMap[customer] = List<Product>()..addAll(products);
    });

    notifyListeners();
  }

  _unSelectAll() {
    selectedCartInfoMap.clear();

    notifyListeners();
  }

  addProduct(List<Customer> customers, Product product) async {
    var iterator = customers.iterator;
    while (iterator.moveNext()) {
      var item = iterator.current;
      if (item != null) {
        await add(item, Product.clone(product));
      }
    }
    notifyListeners();
  }

  add(Customer customerInfo, Product product) async {
    print('@@@ add ==== ');
    if (allCartInfoMap == null) {
      return;
    }
    if (allCartInfoMap.containsKey(customerInfo)) {
      List<Product> products = allCartInfoMap[customerInfo];
      if (products == null) {
        products = List<Product>();
        allCartInfoMap[customerInfo] = products;
      }
      int index = products.indexOf(product);
      if (index >= 0) {
        products[index].count++;
        print('@@@ add ${products[index].count}');
        await DBProvider.db.updateCartProductItem(
            customerInfo.id, product.id, products[index].count);
      } else {
        products.add(product);
        await DBProvider.db
            .insertCartItem(customerInfo.id, product.id, product.count);
      }
    } else {
      allCartInfoMap[customerInfo] = List<Product>()..add(product);
      await DBProvider.db
          .insertCartItem(customerInfo.id, product.id, product.count);
    }
    print('@@@ add end=======');
    notifyListeners();
  }

  remove(Customer customerInfo, Product product) async {
    if (allCartInfoMap == null) {
      return;
    }
    if (selectedCartInfoMap.containsKey(customerInfo)) {
      selectedCartInfoMap[customerInfo]
          .removeWhere((element) => product == element);
      if (selectedCartInfoMap[customerInfo].length == 0) {
        selectedCartInfoMap.remove(customerInfo);
      }
    }
    if (allCartInfoMap.containsKey(customerInfo)) {
      allCartInfoMap[customerInfo].removeWhere((element) => product == element);

      await DBProvider.db.delCartItem(customerInfo.id, product.id);

      if (allCartInfoMap[customerInfo].length == 0) {
        allCartInfoMap.remove(customerInfo);
      }
      checkAllSelected();
      notifyListeners();
    }
  }

  removeSelectedItems() async {
    if (selectedCartInfoMap == null || selectedCartInfoMap.isEmpty) {
      return;
    }
    var mapIterator = selectedCartInfoMap.keys.iterator;
    while (mapIterator.moveNext()) {
      var customer = mapIterator.current;
      if (customer != null) {
        List<Product> products = selectedCartInfoMap[customer];
        var productIt = products.iterator;
        while (productIt.moveNext()) {
          var product = productIt.current;
          if (product != null) {
            if (allCartInfoMap.containsKey(customer)) {
              allCartInfoMap[customer].removeWhere((element) => product == element);

              await DBProvider.db.delCartItem(customer.id, product.id);

              if (allCartInfoMap[customer].length == 0) {
                allCartInfoMap.remove(customer);
              }
            }
          }
        }
      }
    }
    selectedCartInfoMap.clear();
    checkAllSelected();
    notifyListeners();
  }

  bool get isAllSelected => _isAllSelected;

  void handleSelectAll() {
    _isAllSelected = !_isAllSelected;
    _isAllSelected ? _selectAll() : _unSelectAll();
  }

  void decrease(Product product) {
    if (product.count > 1) {
      product.count--;
      notifyListeners();
    }
  }
}

class Product {
  int id;

  String _name;

  int count = 1;

  int price;

  ProductType type;

  String get name {
    if (_name == null) {
      if (type == ProductType.ChuangLian) {
        return "窗帘";
      } else if (type == ProductType.GeLian) {
        return "隔帘";
      }
    }
    return _name;
  }

  set name(String value) {
    _name = value;
  }

  ImageProvider get image {
    if (type == ProductType.ChuangLian) {
      return AssetImage('assets/images/chuanglian.jpeg');
    } else {
      return AssetImage('assets/images/gelian.jpeg');
    }
  }

  @override
  bool operator ==(Object other) {
    return other is Product &&
        other.id == this.id &&
        (other.name == this.name) &&
        (other.type.toString() == this.type.toString());
  }

  @override
  int get hashCode => hashValues(id, name, type);

  @override
  String toString() => toJson();

  static Product clone(Product from) {
    Product product = Product();
    product.id = from.id;
    product.name = from.name;
    product.type = from.type;
    product.count = from.count;
    product.price = from.price;
    return product;
  }

  String toJson() {
    return '{"id":$id,"name":"$name","type":${type.index},"count":$count}';
  }

  static Product fromJson(String json) {
    Map<String, dynamic> product = jsonDecode(json);
    return product == null || product.isEmpty ? null : Product()
      ..id = product['id']
      ..name = product['name']
      ..type = ProductType.values[product['type']]
      ..count = product['count'];
  }

  static Product fromJsonMap(Map<String, dynamic> product) {
    return product == null || product.isEmpty ? null : Product()
      ..id = product['id']
      ..name = product['name']
      ..type = ProductType.values[product['type']]
      ..count = product['count'];
  }


}

enum ProductType {
  ChuangLian,
  GeLian,
  Custom,
}
