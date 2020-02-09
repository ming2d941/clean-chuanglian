import 'package:clean_service/common/database_provider.dart';
import 'package:clean_service/viewmodel/cart_model.dart';
import 'package:clean_service/viewmodel/customer_info.dart';
import 'package:clean_service/viewmodel/main_srceen_model.dart';
import 'package:clean_service/viewmodel/order_model.dart';

class PreloadDataController {
  MainScreenModel mainScreenModel;

  CartModel cartModel;

  OrderModel orderModel;

  PreloadDataController() {
    mainScreenModel = MainScreenModel();
    cartModel = CartModel();
    orderModel = OrderModel();
  }

  Future<void> preLoadData() async {
    print('@@@preLoadData ====');
    List<Customer> customers = await DBProvider.db.getAllCustomers(
        flatCustomers: mainScreenModel.customerController.flatAllCustomer);
    mainScreenModel.customerController.allCustomer = customers;
    Customer customer = customers
        .firstWhere((element) => element.type == CustomerType.bigCustomer);
    mainScreenModel.productController.allProduct =
        await DBProvider.db.getAllProducts(customer);

    cartModel.allCartInfoMap = await DBProvider.db.getAllCartInfo();

    //order
    await orderModel.loadOrders(mainScreenModel.customerController.flatAllCustomer);
    print('@@@ preLoadData end');
  }
}
