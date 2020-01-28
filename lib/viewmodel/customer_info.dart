import 'package:flutter/material.dart';

class  Customer {
  int id;

  String name;

  Customer parent;

  List<Customer> nextInfo;

  CustomerType _type;


  CustomerType get type => _type??parent?._type;

  set type(CustomerType value) {
    _type = value;
  }

  @override
  bool operator ==(Object other) {
    return other is Customer && other.id == this.id
    && (other.name == this.name) && (parent == other.parent);
  }

  @override
  int get hashCode => hashValues(id, name, parent);

  @override
  String toString() => 'id: $id ;name: $name';
}

enum CustomerType {
  personal,
  bigCustomer,
}