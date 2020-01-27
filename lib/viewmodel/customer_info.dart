import 'package:flutter/material.dart';

abstract class Customer {

  CustomerType get type;

  CustomerInfo info;
}

class  CustomerInfo {
  int id;

  String name;

  List<CustomerInfo> nextInfo;

  @override
  bool operator ==(Object other) {
    return other is CustomerInfo && other.id == this.id
    && (other.name == this.name);
  }

  @override
  int get hashCode => hashValues(id, name);

  @override
  String toString() => 'id: $id ;name: $name';
}

class Personal extends Customer {

  @override
  CustomerType get type => CustomerType.personal;
}

class BigCustomer extends Customer {

  @override
  CustomerType get type => CustomerType.bigCustomer;
}

enum CustomerType {
  personal,
  bigCustomer,
}