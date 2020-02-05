import 'package:clean_service/viewmodel/cart_model.dart';

class ProductController {

  List<Product> allProduct;

  ProductController() {
    allProduct = List<Product>()..add(Product()..id = 0..type=ProductType.GeLian)
    ..add(Product()..id = 1..type=ProductType.ChuangLian);
  }
}