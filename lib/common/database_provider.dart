import 'dart:io';

import 'package:clean_service/common/db_to_model.dart';
import 'package:clean_service/config/constant.dart';
import 'package:clean_service/viewmodel/cart_model.dart';
import 'package:clean_service/viewmodel/customer_info.dart';
import 'package:clean_service/viewmodel/order_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  initDB() async {
    print('@@@ initDB');
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'clean_business.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE $TABLE_CUSTOMER("
          "$ID INTEGER PRIMARY KEY,"
          " $NAME TEXT,"
          " $PARENT_ID INTEGER,"
          " $TYPE INTEGER"
          ")");
      await db.execute("CREATE TABLE $TABLE_PRODUCT("
          "$ID INTEGER PRIMARY KEY,"
          " $NAME TEXT,"
          " $COUNT INTEGER,"
          " $USE_TIME INTEGER,"
          " $TYPE INTEGER"
          ")");
      await db.execute("CREATE TABLE $TABLE_CUSTOMER_PRODUCT("
          "$ID INTEGER PRIMARY KEY,"
          " $CUSTOMER_ID INTEGER,"
          " $PRODUCT_ID INTEGER"
          ")");
      await db.execute("CREATE TABLE $TABLE_CART("
          "$ID INTEGER PRIMARY KEY,"
          " $CUSTOMER_ID INTEGER,"
          " $PRODUCT_ID INTEGER,"
          " $COUNT INTEGER,"
          " $START_TIME REAL,"
          " $END_TIME REAL"
          ")");

      await db.execute("CREATE TABLE $TABLE_ORDER("
          "$ID INTEGER PRIMARY KEY,"
          " $CUSTOMER_ID INTEGER,"
          " $PRODUCTS TEXT,"
          " $ORDER_STATUS INTEGER,"
          " $SIGNATURE_PATH TEXT,"
          " $ORDER_IMAGE_PATH TEXT,"
          " $START_TIME REAL,"
          " $END_TIME REAL"
          ")");

      await initCustomerTable(db);
    });
  }

  initProductTable(Database db, int customerId) async {
    int chuangLianId = await db.insert(TABLE_PRODUCT, toProductMap('窗帘'));
    int geLianId = await db.insert(
        TABLE_PRODUCT, toProductMap('隔帘', type: ProductType.GeLian));

    await db.insert(
        TABLE_CUSTOMER_PRODUCT, toCustomerProductMap(customerId, chuangLianId));
    await db.insert(
        TABLE_CUSTOMER_PRODUCT, toCustomerProductMap(customerId, geLianId));
  }

  initCustomerTable(Database db) async {
    print('@@@initCustomerTable');
    int rootId = await db.insert(TABLE_CUSTOMER, toCustomerMap('脑科医院'));
    int waiKeId =
        await db.insert(TABLE_CUSTOMER, toCustomerMap('外科楼', parentId: rootId));
    int neiKeId =
        await db.insert(TABLE_CUSTOMER, toCustomerMap('内科楼', parentId: rootId));
    int jiZhenId =
        await db.insert(TABLE_CUSTOMER, toCustomerMap('急诊楼', parentId: rootId));
    int banGongId = await db.insert(
        TABLE_CUSTOMER, toCustomerMap('儿科/办公楼', parentId: rootId));

    await db.insert(TABLE_CUSTOMER, toCustomerMap('9病区', parentId: waiKeId));
    await db.insert(TABLE_CUSTOMER, toCustomerMap('8病区', parentId: waiKeId));
    await db.insert(TABLE_CUSTOMER, toCustomerMap('7病区', parentId: waiKeId));
    await db.insert(TABLE_CUSTOMER, toCustomerMap('6病区', parentId: waiKeId));
    await db.insert(TABLE_CUSTOMER, toCustomerMap('ICU', parentId: waiKeId));
    await db.insert(TABLE_CUSTOMER, toCustomerMap('手术室', parentId: waiKeId));
    await db.insert(TABLE_CUSTOMER, toCustomerMap('康复室', parentId: waiKeId));

    await db.insert(TABLE_CUSTOMER, toCustomerMap('1病区', parentId: neiKeId));
    await db.insert(TABLE_CUSTOMER, toCustomerMap('2病区', parentId: neiKeId));
    await db.insert(TABLE_CUSTOMER, toCustomerMap('3病区', parentId: neiKeId));
    await db.insert(TABLE_CUSTOMER, toCustomerMap('4病区', parentId: neiKeId));
    await db.insert(TABLE_CUSTOMER, toCustomerMap('5病区', parentId: neiKeId));

    await db.insert(TABLE_CUSTOMER, toCustomerMap('1楼门诊', parentId: jiZhenId));
    await db.insert(TABLE_CUSTOMER, toCustomerMap('1楼急诊', parentId: jiZhenId));
    await db.insert(TABLE_CUSTOMER, toCustomerMap('内镜室', parentId: jiZhenId));
    await db.insert(TABLE_CUSTOMER, toCustomerMap('11病区', parentId: jiZhenId));
    await db.insert(TABLE_CUSTOMER, toCustomerMap('12病区', parentId: jiZhenId));
    await db.insert(TABLE_CUSTOMER, toCustomerMap('13病区', parentId: jiZhenId));
    await db.insert(TABLE_CUSTOMER, toCustomerMap('连廊', parentId: jiZhenId));

    await db.insert(TABLE_CUSTOMER, toCustomerMap('儿科', parentId: banGongId));
    await db.insert(TABLE_CUSTOMER, toCustomerMap('办公楼', parentId: banGongId));

    await db.insert(
        TABLE_CUSTOMER, toCustomerMap('个人用户', type: CustomerType.personal));

    await initProductTable(db, rootId);
  }

  Future<List<Customer>> getAllCustomers(
      {List<Customer> flatCustomers, Customer parent, int id = -1}) async {
    final db = await database;

    final cursor = await db
        .query(TABLE_CUSTOMER, where: "$PARENT_ID = ?", whereArgs: [id]);

    List<Customer> customers = List<Customer>();
    var iterator = cursor.iterator;
    while (cursor.isNotEmpty && iterator.moveNext()) {
      var item = iterator.current;
      if (item != null) {
        Customer customer = Customer()
          ..id = item[ID]
          ..name = item[NAME]
          ..parent = parent
          ..type = CustomerType.values[item[TYPE]];

        customer.children = await getAllCustomers(
            flatCustomers: flatCustomers, parent: customer, id: customer.id);
        customers.add(customer);
        flatCustomers.add(customer);
      }
    }
    return customers;
  }

  Future<List<Product>> getAllProducts(Customer customer) async {
    final db = await database;

    List<Product> products = List<Product>();
    if (customer == null) {
      return products;
    }

    final cursor = await db.query(TABLE_CUSTOMER_PRODUCT,
        where: "$CUSTOMER_ID = ?", whereArgs: [customer.id]);

    var iterator = cursor.iterator;
    while (cursor.isNotEmpty && iterator.moveNext()) {
      var item = iterator.current;
      if (item != null) {
        int id = item[ID];
        var curProducts =
            await db.query(TABLE_PRODUCT, where: "$ID = ?", whereArgs: [id]);
        curProducts.forEach((element) {
          products.add(Product()
            ..id = element[ID]
            ..count = element[COUNT]
            ..name = element[NAME]
            ..type = ProductType.values[element[TYPE]]);
        });
      }
    }
    return products;
  }

  getAllCartInfo() async {
    print('@@@getAllCartInfo');
    final db = await database;
    Map<Customer, List<Product>> allCartInfoMap =
        Map<Customer, List<Product>>();

    final cursor = await db.query(TABLE_CART);
    if (cursor.isEmpty) {
      return allCartInfoMap;
    }

    getCustomer(int id) async {
      print('@@@ getCustomer $id');
      if (id == -1) {
        return null;
      }
      Customer product;
      var customerInfo =
          await db.query(TABLE_CUSTOMER, where: "$ID = ?", whereArgs: [id]);
      if (customerInfo.isNotEmpty) {
        var info = customerInfo[0];

        product = Customer()
          ..id = info[ID]
          ..name = info[NAME]
          ..type = CustomerType.values[info[TYPE]]
          ..parent = await getCustomer(info[PARENT_ID]);
        print('@@@ getCustomer $product');
      }
      return product;
    }

    add(Customer customerInfo, Product product) {
      print('@@@ add $customerInfo $product');
      if (allCartInfoMap.containsKey(customerInfo)) {
        List<Product> products = allCartInfoMap[customerInfo];
        if (products == null) {
          products = List<Product>();
          allCartInfoMap[customerInfo] = products;
        }
        int index = products.indexOf(product);
        if (index >= 0) {
          products[index].count++;
        } else {
          products.add(product);
        }
      } else {
        allCartInfoMap[customerInfo] = List<Product>()..add(product);
      }
    }

    final iterator = cursor.iterator;
    while (iterator.moveNext()) {
      var item = iterator.current;
      if (item != null) {
        Customer customer = await getCustomer(item[CUSTOMER_ID]);
        Product product = await getProduct(item[PRODUCT_ID]);
        product.count = item[COUNT];

        print('@@@ $customer $product');

        add(customer, product);
      }
    }
    return allCartInfoMap;
  }

  getProduct(int id) async {
    final db = await database;

    Product product;
    var productInfo =
        await db.query(TABLE_PRODUCT, where: "$ID = ?", whereArgs: [id]);
    if (productInfo.isNotEmpty) {
      var info = productInfo[0];
      product = Product()
        ..id = info[ID]
        ..name = info[NAME]
        ..type = ProductType.values[info[TYPE]];
    }
    return product;
  }

//  getCustomer(List<Customer> allCustomer, int id) {
//    if (allCustomer.isEmpty) {
//      return null;
//    }
//    allCustomer.firstWhere((element) {
//      return element.id == id;
//    });
//  }

  Future<int> insertCartItem(int customerId, int productId, int count) async {
    print('@@@@ insertCartItem $customerId $productId $count');
    final db = await database;

    var result =
        await db.insert(TABLE_CART, toCartMap(customerId, productId, count));
    print('@@@@ insertCartItem $result');
    return result;
  }

  Future<int> updateCartProductItem(
      int customerId, int productId, int count) async {
    print('@@@@ updateCartProductItem $customerId $productId $count');
    final db = await database;

    var result = await db.update(
      TABLE_CART,
      toCartMap(customerId, productId, count),
      where: "$CUSTOMER_ID = ? AND $PRODUCT_ID = ?",
      whereArgs: [customerId, productId],
    );

    print('@@@@ updateCartProductItem $result');
    var rrr = await db.query(TABLE_CART,
        where: "$CUSTOMER_ID = ? AND $PRODUCT_ID = ?",
        whereArgs: [customerId, productId]);
    print('@@@ ${rrr.length}');
    rrr.forEach((element) {
      if (element != null) {
        print('@@@ ${element[COUNT]}');
      }

    });
    return result;
  }

  Future<int> delCartItem(int customerId, int productId) async {
    print('@@@@ delCartItem $customerId $productId');
    final db = await database;

    var result = await db.delete(
      TABLE_CART,
      where: "$CUSTOMER_ID = ?  AND $PRODUCT_ID = ?",
      whereArgs: [customerId, productId],
    );
    print('@@@@ delCartItem $result');
    return result;
  }

  Future<int> insetOrder(OrderInfo orderInfo) async {
    print('@@@@ insetOrder $orderInfo');
    final db = await database;

    if (orderInfo == null) {
      return -1;
    }

    var result = await db.insert(TABLE_ORDER, toOrderMap(orderInfo));
    print('@@@@ insetOrder $result');

    return result;
  }

  Future<int> updateOrderItem(OrderInfo orderInfo) async {
    print('@@@@ updateOrderItem $orderInfo');
    final db = await database;

    var result = await db.update(
      TABLE_ORDER,
      toOrderMap(orderInfo),
      where: "$ID = ?",
      whereArgs: [orderInfo.id],
    );
    print('@@@@ updateOrderItem $result');
    return result;
  }

  Future<int> delOrder(int id) async {
    print('@@@@ delOrder $id');
    final db = await database;

    var result = await db.delete(
      TABLE_ORDER,
      where: "$ID = ?",
      whereArgs: [id],
    );
    print('@@@@ delOrder $result');
    return result;
  }

  Future<List<OrderInfo>> getAllOrderInfo(
      List<Customer> flatAllCustomer) async {
    print('@@@getAllOrderInfo');
    final db = await database;

    List<OrderInfo> allOrders = List<OrderInfo>();

    final cursor = await db.query(TABLE_ORDER);
    if (cursor.isEmpty) {
      return allOrders;
    }

    cursor.forEach((item) {
      print('@@@getAllOrderInfo $item');
      if (item != null) {
        OrderInfo orderInfo = OrderInfo();
        orderInfo.id = item[ID];
        print('@@@getAllOrderInfo--> id ${orderInfo.id}');
        orderInfo.customer = flatAllCustomer
            .firstWhere((element) => element.id == item[CUSTOMER_ID]);
        print('@@@getAllOrderInfo--> customer ${orderInfo.customer}');
        orderInfo.status = OrderStatus.values[item[ORDER_STATUS]];
        print('@@@getAllOrderInfo--> status ${orderInfo.status}');
        orderInfo.startTime = item[START_TIME];
        orderInfo.signatureImage = item[SIGNATURE_PATH];
        orderInfo.orderImage = item[ORDER_IMAGE_PATH];
        orderInfo.products = toProductList(item[PRODUCTS]);
        print('@@@getAllOrderInfo --- $orderInfo');
        allOrders.add(orderInfo);
      }
    });
    return allOrders;
  }
}
