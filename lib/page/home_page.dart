import 'package:clean_service/common/database_provider.dart';
import 'package:clean_service/common/db_to_model.dart';
import 'package:clean_service/config/ui_style.dart';
import 'package:clean_service/viewmodel/cart_model.dart';
import 'package:clean_service/viewmodel/customer_info.dart';
import 'package:clean_service/viewmodel/main_srceen_model.dart';
import 'package:clean_service/widget/custom_product_item.dart';
import 'package:clean_service/widget/customer_options.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _height;
  double _width;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Consumer<MainScreenModel>(
        builder: (context, mainScreenModel, child) {
      return Scaffold(
        backgroundColor: Colors.grey[90],
        key: scaffoldKey,
        body: Stack(children: <Widget>[
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              width: _width,
              height: 210,
              child: Stack(
                children: <Widget>[
                  Image.asset('assets/images/clean_water.png',
                      fit: BoxFit.fill, width: _width),
                  Container(
                    color: Color(0x55000000),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(bottom: 20),
                child: Text('首页', style: AppTextStyle.main_menu),
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.person_pin_circle,
                    color: Colors.white,
                    size: 30,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  PopupMenuButton(
                    onSelected: (index) {
                      mainScreenModel.setCustomerIndex(index);
                    },
                    child: Row(
                      children: <Widget>[
                        Text(
                          mainScreenModel.customerController.current?.name ??
                              '未知',
                          style: AppTextStyle.dropdown_menu,
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 30,
                        )
                      ],
                    ),
                    itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
                      PopupMenuItem(
                        child: Text(mainScreenModel
                            .customerController.allCustomer[0].name),
                        value: 0,
                      ),
                      PopupMenuItem(
                        child: Text(mainScreenModel
                                .customerController.allCustomer[1].name
//                                locations[1],
//                                style: dropdownMenuItem,
                            ),
                        value: 1,
                      ),
                    ],
                  ),
                ],
              ),
              _buildTaskRow(context),
              _buildProductList(context,
                  mainScreenModel), //, mainScreenModel.customerController
//              _expandListView(context, mainScreenModel),
            ]),
          ),
        ]),
      );
    });
  }

  _buildTaskRow(BuildContext context) {
    return Container(
      width: _width,
      height: 100,
      margin: EdgeInsets.fromLTRB(0, 35, 0, 0),
      child: Row(
        children: <Widget>[
          Flexible(
            fit: FlexFit.tight,
            child: GestureDetector(
              onTap: () {
                toast("建设中，敬请期待...");
              },
              child: Card(
                color: Colors.grey[90],
                child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Image.asset(
                          'assets/images/task_planning.png',
                          width: 50,
                        ),
                        Text('今日任务'),
                      ],
                    )),
              ),
            ),
            flex: 1,
          ),
          Container(
            width: 10,
          ),
          Flexible(
            fit: FlexFit.tight,
            child: GestureDetector(
              onTap: () {
                toast("建设中，敬请期待...");
              },
              child: Card(
                color: Colors.grey[90],
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/calendar.png',
                        width: 50,
                      ),
                      Text('未来安排'),
                    ],
                  ),
                ),
              ),
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }

  _buildProductList(BuildContext context, MainScreenModel model) {
    var empty = Expanded(child: Container(
        alignment: Alignment.center, child: Text('空空如也~')),);
    Customer customer = model.customerController.current;
    if (customer == null) {
      return empty;
    }
    var productList = model.productController.allProduct[customer];
    if (productList == null || productList.isEmpty) {
      return empty;
    }
    var list = productList.map((product) => _buildProductItem(model, product))
        .toList();
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 20),
        width: _width,
        child: Column(
          children: <Widget>[
            list[0],
            Container(
              height: 20,
            ),
            list[1],
          ],
        ),
      ),
    );
  }

  _buildProductItem(MainScreenModel model, Product product) {
    return Flexible(
      flex: 1,
      fit: FlexFit.tight,
      child: GestureDetector(
        onTap: () {
          _cartPressed(context, model, product);
        },
        child: Container(
        width: _width,
        child: LayoutBuilder(
          builder: (context, constraints) {
            double height = constraints.constrainHeight();
            double width = constraints.constrainWidth();
            double size = height - 40;
            return Stack(
              children: <Widget>[
                Positioned(
                  left: size / 2,
                  width: width - size / 2,
                  height: height,
                  child: Card(
                    elevation: 1,
                    color: Colors.grey[90],
                    child: Stack(children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            padding:
                            EdgeInsets.only(left: size / 2 + 10, top: 30),
                            alignment: Alignment.topLeft,
                            child: Text(product.name,
                                style: AppTextStyle.home_product_title),
                          ),
                          Container(
                            padding:
                            EdgeInsets.only(left: size / 2 + 10, top: 5),
                            alignment: Alignment.topLeft,
                            child: Text('脑科医院各科室${product.name}',
                                style: AppTextStyle.home_product_sub_title),
                          )
                        ],
                      ),
                      Align(alignment: Alignment(0.8, 0.6),
                        child: Icon(Icons.shopping_cart, color: Colors.blue,),),
                    ],),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Image(
                      image: product.image,
                      fit: BoxFit.fill,
                      width: size,
                      height: size,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),),
    );
  }

  _cartPressed(
      BuildContext context, MainScreenModel model, Product curProduct) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => BottomSheet(
        builder: (_) => CustomerOptionsDialog(
            currentCustomer: model.customerController?.current,
            closeCallback: (List<Customer> selectedCustomer) {
              Provider.of<CartModel>(context)
                  .addProduct(selectedCustomer, curProduct);
            }),
        onClosing: () {},
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height);

    var firstEndPoint = Offset(size.width / 2, size.height - 30);
    var firstControlPoint = Offset(size.width / 4, size.height - 53);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    var secondEndPoint = Offset(size.width, size.height - 90);
    var secondControlPoint = Offset(size.width * 3 / 4, size.height - 14);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
