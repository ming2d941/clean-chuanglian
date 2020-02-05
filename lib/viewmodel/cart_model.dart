import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'customer_info.dart';

class CartModel extends ChangeNotifier {
  Map<Customer, List<Product>> allCartInfoMap;
  Map<Customer, List<Product>> selectedCartInfoMap;
  bool _isAllSelected = false;
  Function _ListEquals;

  CartModel() {
    _ListEquals = const ListEquality().equals;
    allCartInfoMap = Map<Customer, List<Product>>();
    selectedCartInfoMap = Map<Customer, List<Product>>();
  }

  isSelectCustomer(Customer customer) {
    return selectedCartInfoMap.containsKey(customer) &&
        _ListEquals(selectedCartInfoMap[customer], allCartInfoMap[customer]);
  }

  selectAllProductOfCustomer(Customer customerInfo) {
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
    return _isAllSelected = MapEquality(values: ListEquality())
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

  addProduct(List<Customer> customers, Product product) {
    customers.forEach((customer) {
      add(customer, Product.clone(product));
    });
    notifyListeners();
  }

  add(Customer customerInfo, Product product) {
    if (allCartInfoMap.containsKey(customerInfo)) {
      List<Product> products = allCartInfoMap[customerInfo];
      if (products == null) {
        products = List<Product>();
        allCartInfoMap[customerInfo] = products;
      }
      int index = products.indexOf(product);
      if (index >= 0) {
        products[index].count++;
      } else {
        products.add(product);
      }
    } else {
      allCartInfoMap[customerInfo] = List<Product>()..add(product);
    }
    notifyListeners();
  }

  remove(Customer customerInfo, Product product) {
    if (allCartInfoMap.containsKey(customerInfo)) {
      allCartInfoMap[customerInfo].removeWhere((element) {
        if (product == element) {
          if (product.count > 1) {
            product.count--;
            return false;
          } else {
            return true;
          }
        } else {
          return false;
        }
      });
      if (allCartInfoMap[customerInfo].length == 0) {
        allCartInfoMap.remove(customerInfo);
      }
    }

    notifyListeners();
  }

  bool get isAllSelected => _isAllSelected;

  void handleSelectAll() {
    _isAllSelected = !_isAllSelected;
    _isAllSelected ? _selectAll() : _unSelectAll();
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
  String toString() => 'id: $id ;name: $name;type: $type';

  static Product clone(Product from) {
    Product product = Product();
    product.id = from.id;
    product.name = from.name;
    product.type = from.type;
    product.count = from.count;
    product.price = from.price;
    return product;
  }
}

enum ProductType {
  ChuangLian,
  GeLian,
  Custom,
}
