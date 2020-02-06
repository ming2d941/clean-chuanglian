import 'package:clean_service/config/constant.dart';
import 'package:clean_service/viewmodel/cart_model.dart';
import 'package:clean_service/viewmodel/customer_info.dart';

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
