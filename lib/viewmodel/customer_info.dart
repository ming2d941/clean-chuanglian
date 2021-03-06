import 'package:flutter/material.dart';

class Customer {
  int id;

  String name;

  Customer parent;

  List<Customer> children;

  CustomerType _type;

  CustomerType get type => _type ?? parent?._type;

  set type(CustomerType value) {
    _type = value;
  }

  @override
  bool operator ==(Object other) {
    return other is Customer &&
        other.id == this.id &&
        (other.name == this.name) &&
        (parent == other.parent);
  }

  @override
  int get hashCode => hashValues(id, name, parent);

  @override
  String toString() => 'id: $id ;name: $name ; parent: ${parent == null? 'null' : parent.name}';

  List<String> fullNames() {
    List<String> list = List<String>();
    Customer customer = this;
    do {
      list.insert(0, customer.name);
      customer = customer.parent;
    } while (customer != null);
    return list;
  }

  defaultTitleRow() {
    var nameList = fullNames();
    return Row(children: nameList.map((name) {
      var index = nameList.indexOf(name);
      return Row(
        children: <Widget>[
          Text(name),
          index != nameList.length - 1
              ? Icon(
            Icons.arrow_right,
            color: Colors.grey,
          )
              : Container(),
        ],
      );
    }).toList(),);
  }
}

enum CustomerType {
  personal,
  bigCustomer,
}



