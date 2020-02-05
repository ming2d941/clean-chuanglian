import 'package:clean_service/config/ui_style.dart';
import 'package:clean_service/viewmodel/cart_model.dart';
import 'package:clean_service/viewmodel/customer_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartModel>(builder: (context, cartModel, child) {
      return Scaffold(
          backgroundColor: Colors.grey[90],
          body: _isCartEmpty(cartModel)
              ? _showCartEmpty(cartModel)
              : _showCartContent(cartModel));
    });
  }

  _isCartEmpty(CartModel cartModel) {
    return cartModel == null ||
        cartModel.allCartInfoMap == null ||
        cartModel.allCartInfoMap.length <= 0;
  }

  _showCartEmpty(CartModel cartModel) {
    return Center(
      child: Text('No Data!!!'),
    );
  }

  _showCartContent(CartModel cartModel) {
    return Column(
      children: <Widget>[
        Expanded(
            child: ListView.builder(
                itemCount: cartModel.allCartInfoMap.length,
                itemBuilder: (context, index) {
                  return _cartItem(cartModel, index);
                })),
        Material(
          elevation: 20.0,
          child: Container(
            padding: const EdgeInsets.only(left: 15, right: 15),
            height: 70,
            child: Row(
              children: <Widget>[
                GestureDetector(
                  child: Row(
                    children: <Widget>[
                      cartModel.isAllSelected
                          ? Icon(Icons.check_circle, color: Colors.red)
                          : Icon(Icons.radio_button_unchecked,
                              color: Colors.grey),
                      SizedBox(width: 10.0),
                      Text(
                        '全选',
                      ),
                    ],
                  ),
                  onTap: () => _selectAllPress(cartModel),
                ),
                Spacer(),
                GestureDetector(
                  child: Container(
                      height: 40,
                      width: 70,
                      margin: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(21.0),
                              bottomLeft: const Radius.circular(21.0),
                              topRight: const Radius.circular(21.0),
                              bottomRight: const Radius.circular(21.0))),
                      alignment: Alignment.center,
                      child: Text('下单', style: AppTextStyle.text_regular_15)),
                  onTap: () => _goOrderPage(context),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _cartItem(CartModel cartModel, int index) {
    var customer = cartModel.allCartInfoMap.keys.elementAt(index);
    List<Product> products = cartModel.allCartInfoMap[customer];
    var nameList = customer.fullNames();

    var title = () {
      List<Widget> titleChildren = List<Widget>();
      List<Widget> titleText = nameList.map((name) {
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
      }).toList();
      titleChildren.add(
        GestureDetector(
          child: Container(
            margin: EdgeInsets.only(right: 10),
            child: cartModel.isSelectCustomer(customer)
                ? Icon(Icons.check_circle, color: Colors.red)
                : Icon(Icons.radio_button_unchecked, color: Colors.grey),
          ),
          onTap: () => _selectCustomer(cartModel, customer),
        ),
      );
      titleChildren.addAll(titleText);
      return Container(
        height: 45,
        child: Row(children: titleChildren),
      );
    };

    var item = (Product product) {
      return Dismissible(
        key: Key(customer.toString() + product.toString()),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          cartModel.remove(customer, product);
        },
        // Show a red background as the item is swiped away.
        background: Container(
          padding: EdgeInsets.only(right: 20),
          alignment: Alignment.centerRight,
          color: Colors.red,
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: Row(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  margin: EdgeInsets.only(right: 10),
                  child: cartModel.isSelect(customer, product)
                      ? Icon(Icons.check_circle, color: Colors.red)
                      : Icon(Icons.radio_button_unchecked, color: Colors.grey),
                ),
                onTap: () => _selectProduct(cartModel, customer, product),
              ),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                    image: DecorationImage(
//                  image: CachedNetworkImageProvider(images[1]),
                  image: AssetImage('assets/images/gelian.jpeg'),
                  fit: BoxFit.cover,
                )),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              product.name,
                              overflow: TextOverflow.fade,
                              softWrap: true,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                          ),
                          Container(
                            width: 50,
                            child: IconButton(
                              onPressed: () {
                                print("Button Pressed");
                              },
                              color: Colors.red,
                              icon: Icon(Icons.delete),
                              iconSize: 20,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text("Price: "),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '\$200',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w300),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text("Sub Total: "),
                          SizedBox(
                            width: 5,
                          ),
                          Text('\$400',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: Colors.orange,
                              ))
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            "Ships Free",
                            style: TextStyle(color: Colors.orange),
                          ),
                          Spacer(),
                          Row(
                            children: <Widget>[
                              InkWell(
                                onTap: () {},
                                splashColor: Colors.redAccent.shade200,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50)),
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Icon(
                                      Icons.remove,
                                      color: Colors.redAccent,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('2'),
                                ),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              InkWell(
                                onTap: () {},
                                splashColor: Colors.lightBlue,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50)),
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.green,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    };

    List<Widget> children = List<Widget>();
    children.add(title());
    products.forEach((product) {
      children.add(item(product));
    });

    return Card(
      margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: EdgeInsets.all(7),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  _goOrderPage(BuildContext context) {}

  _selectAllPress(CartModel cartModel) {
    cartModel.handleSelectAll();

  }

  _selectCustomer(CartModel cartMode, Customer customer) {
    cartMode.selectAllProductOfCustomer(customer);
  }

  _selectProduct(CartModel cartMode, Customer customer, Product product) {
    cartMode.selectProduct(customer, product);
  }
}
