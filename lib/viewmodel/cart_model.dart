import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'customer_info.dart';

class CartModel extends ChangeNotifier {
  Map<Customer, List<Product>> allCartInfoMap;
  Map<Customer, List<Product>> selectedCartInfoMap;
  bool isAllSelected = false;

  CartModel() {
    allCartInfoMap = Map<Customer, List<Product>>();
    selectedCartInfoMap = Map<Customer, List<Product>>();
  }

  isSelectCustomer(Customer customer) {
    return selectedCartInfoMap.containsKey(customer)
        && ListEquality().equals(selectedCartInfoMap[customer], allCartInfoMap[customer]);
  }

  selectAllProductOfCustomer(Customer customerInfo) {
    bool isCurSelected = isSelectCustomer(customerInfo);

    selectedCartInfoMap.remove(customerInfo);
    if (!isCurSelected) {
      selectedCartInfoMap[customerInfo] = List<Product>();
      allCartInfoMap[customerInfo].forEach((product) {
        product.isSelected = true;
        selectedCartInfoMap[customerInfo].add(product);
      });
    } else {
      allCartInfoMap[customerInfo].forEach((product) {
        product.isSelected = false;
      });
    }
    notifyListeners();
  }

  select(Customer customerInfo, Product product) {
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
    product.isSelected = true;

    notifyListeners();
  }

  unSelect(Customer customerInfo, Product product) {
    if (selectedCartInfoMap.containsKey(customerInfo)) {
      selectedCartInfoMap[customerInfo]
          .removeWhere((element) => product == element);
      product.isSelected = false;
      if (selectedCartInfoMap[customerInfo].length == 0) {
        selectedCartInfoMap.remove(customerInfo);
      }
      isAllSelected = selectedCartInfoMap.length == allCartInfoMap.length;
    }

    notifyListeners();
  }

  selectAll() {
    selectedCartInfoMap.clear();
    allCartInfoMap.forEach((customer, products) {
      products.forEach((element) {
        element.isSelected = true;
      });
      selectedCartInfoMap[customer] = List<Product>()..addAll(products);
    });

    notifyListeners();
  }

  unSelectAll() {
    allCartInfoMap.forEach((customer, products) {
      products.forEach((product) {
        product.isSelected = false;
      });
    });
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
      if (products.remove(product)) {
        product.count++;
      }
      products.add(product);
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

  void handleSelectAll() {
    isAllSelected = !isAllSelected;
    print('$isAllSelected');
    isAllSelected ? selectAll() : unSelectAll();
  }

  void selectProduct(Customer customer, Product product) {
    product.isSelected = !product.isSelected;
    product.isSelected
        ? select(customer, product)
        : unSelect(customer, product);
  }
}

class Product {
  int id;

  String _name;

  int count = 1;

  int price;

  ProductType type;

  bool isSelected = false;

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
    return other is Product && other.id == this.id && (other.name == this.name)
        && (other.type == this.type);
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
    product.isSelected = from.isSelected;
    return product;
  }
}

enum ProductType {
  ChuangLian,
  GeLian,
  Custom,
}
