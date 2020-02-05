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
              height: 200,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xfffb53c6), Color(0xffb91d73)])),
            ),
          ),
          Column(children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.person_pin_circle,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  PopupMenuButton(
                    onSelected: (index) {
                      mainScreenModel.setCustomerIndex(index);
                    },
                    child: Row(
                      children: <Widget>[
                        Text(mainScreenModel.customerController.current.name ??
                                '未知'
//                                locations[selectedLocationIndex],
//                                style: dropdownMenuLabel,
                            ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                        )
                      ],
                    ),
                    itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
                      PopupMenuItem(
                        child: Text(mainScreenModel
                                .customerController.allCustomer[0].name
//                                locations[0],
//                                style: dropdownMenuItem,
                            ),
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
                  Spacer(),
                  Icon(
                    Icons.settings,
                    color: Colors.white,
                  )
                ],
              ),
            ),
            _expandListView(context,
                mainScreenModel), //, mainScreenModel.customerController
          ])
        ]),
      );
    });
  }

  _expandListView(BuildContext context, MainScreenModel model) {
//    MainScreenModel model = Provider.of<MainScreenModel>(context);
    return Expanded(
      child: ExpandableTheme(
        data: ExpandableThemeData(iconColor: Colors.blue, useInkWell: false),
        child: ListView(
          children: <Widget>[
            GestureDetector(
                child: CustomProductItem(),
                onTap: () {
                  _cartPressed(context, model, Product()..id = 0..type=ProductType.GeLian);
                }),
            CustomProductItem(),
            CustomProductItem(),
            CustomProductItem(),
            CustomProductItem(),
            CustomProductItem(),
            CustomProductItem(),
            CustomProductItem(),
            CustomProductItem(),
          ],
        ),
      ),
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
