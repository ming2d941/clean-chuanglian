import 'customer_info.dart';

class CustomerController {

  List<Customer> allCustomer;
  List<Customer> flatAllCustomer = List<Customer>();

  int _index = 0;

  Customer get current => allCustomer?.elementAt(_index);

  set index(int value) {
    _index = value;
  }
}