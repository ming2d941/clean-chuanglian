import 'dart:io';

import 'package:clean_service/common/db_to_model.dart';
import 'package:clean_service/config/constant.dart';
import 'package:clean_service/viewmodel/cart_model.dart';
import 'package:clean_service/viewmodel/customer_info.dart';
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
          " $PRODUCT_ID INTEGER,"
          " $COUNT INTEGER,"
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
    int cateId0 =
        await db.insert(TABLE_CUSTOMER, toCustomerMap('外科楼', parentId: rootId));
    int cateId1 =
        await db.insert(TABLE_CUSTOMER, toCustomerMap('内科楼', parentId: rootId));
    int cateId2 =
        await db.insert(TABLE_CUSTOMER, toCustomerMap('急诊楼', parentId: rootId));
    int cateId3 = await db.insert(
        TABLE_CUSTOMER, toCustomerMap('儿科/办公楼', parentId: rootId));

    await db.insert(TABLE_CUSTOMER, toCustomerMap('9病区', parentId: cateId0));
    await db.insert(TABLE_CUSTOMER, toCustomerMap('8病区', parentId: cateId0));
    await db.insert(TABLE_CUSTOMER, toCustomerMap('7病区', parentId: cateId0));
    await db.insert(TABLE_CUSTOMER, toCustomerMap('6病区', parentId: cateId0));
    await db.insert(TABLE_CUSTOMER, toCustomerMap('ICU', parentId: cateId0));
    await db.insert(TABLE_CUSTOMER, toCustomerMap('手术室', parentId: cateId0));
    await db.insert(TABLE_CUSTOMER, toCustomerMap('康复室', parentId: cateId0));

    await db.insert(TABLE_CUSTOMER, toCustomerMap('1病区', parentId: cateId1));
    await db.insert(TABLE_CUSTOMER, toCustomerMap('2病区', parentId: cateId1));
    await db.insert(TABLE_CUSTOMER, toCustomerMap('3病区', parentId: cateId1));
    await db.insert(TABLE_CUSTOMER, toCustomerMap('4病区', parentId: cateId1));
    await db.insert(TABLE_CUSTOMER, toCustomerMap('5病区', parentId: cateId1));

    await db.insert(TABLE_CUSTOMER, toCustomerMap('1楼门诊', parentId: cateId2));
    await db.insert(TABLE_CUSTOMER, toCustomerMap('1楼急诊', parentId: cateId2));
    await db.insert(TABLE_CUSTOMER, toCustomerMap('内镜室', parentId: cateId2));
    await db.insert(TABLE_CUSTOMER, toCustomerMap('11病区', parentId: cateId2));
    await db.insert(TABLE_CUSTOMER, toCustomerMap('12病区', parentId: cateId2));
    await db.insert(TABLE_CUSTOMER, toCustomerMap('13病区', parentId: cateId2));
    await db.insert(TABLE_CUSTOMER, toCustomerMap('连廊', parentId: cateId2));

    await db.insert(TABLE_CUSTOMER, toCustomerMap('儿科', parentId: cateId3));
    await db.insert(TABLE_CUSTOMER, toCustomerMap('办公楼', parentId: cateId3));

    await db.insert(TABLE_CUSTOMER, toCustomerMap('个人用户', type: CustomerType.personal));

    await initProductTable(db, rootId);
  }

  Future<List<Customer>> getCustomers({Customer parent, int id = -1}) async {
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

        customer.children =
            await getCustomers(parent: customer, id: customer.id);
        customers.add(customer);
      }
    }
    return customers;
  }

  Future<List<Product>> getProduct(Customer customer) async {
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
}
