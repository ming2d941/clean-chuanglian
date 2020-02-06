import 'package:clean_service/common/database_provider.dart';
import 'package:clean_service/viewmodel/cart_model.dart';
import 'package:clean_service/viewmodel/customer_info.dart';
import 'package:clean_service/viewmodel/main_srceen_model.dart';

class PreloadDataController {

  MainScreenModel mainScreenModel;

  CartModel cartModel;

  PreloadDataController() {
    mainScreenModel = MainScreenModel();
    cartModel = CartModel();
  }

  Future<void> preLoadData() async {
    List<Customer> customers = await DBProvider.db.getCustomers();
    mainScreenModel.customerController.allCustomer = customers;
    Customer customer = customers.firstWhere((element) => element.type == CustomerType.bigCustomer);
    mainScreenModel.productController.allProduct =
    await DBProvider.db.getProduct(customer);
    print('@@@preLoadData');
//    cartModel.allCartInfoMap = await DBProvider.db.getCartInfo();
  }


}