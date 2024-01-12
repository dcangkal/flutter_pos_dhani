import 'package:sqflite/sqflite.dart';

import '../../presentation/home/models/order_item.dart';
import '../../presentation/order/models/order_model.dart';
import '../models/request/order_request_model.dart';
import '../models/response/product_response_model.dart';

class ProductLocalDatasource {
  ProductLocalDatasource._init();

  static final ProductLocalDatasource instance = ProductLocalDatasource._init();

  final String tableProducts = 'products';

  static Database? _database;

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = dbPath + filePath;

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableProducts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER,
        name TEXT,
        price INTEGER,
        stock INTEGER,
        image TEXT,
        category TEXT,
        is_best_seller INTEGER,
        is_sync INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nominal INTEGER,
        payment_method TEXT,
        total_item INTEGER,
        id_kasir INTEGER,
        nama_kasir TEXT,
        transaction_time TEXT,
        is_sync INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE order_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_order INTEGER,
        id_product INTEGER,
        quantity INTEGER,
        price INTEGER
      )
    ''');
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('pos1.db');
    return _database!;
  }

  Future<void> removeAllProduct() async {
    final db = await instance.database;
    await db.delete(tableProducts);
  }

  Future<void> insertAllProduct(List<Product> products) async {
    final db = await instance.database;
    for (var product in products) {
      await db.insert(tableProducts, product.toLocalMap());
    }
  }

  Future<Product> insertProduct(Product product) async {
    final db = await instance.database;
    int id = await db.insert(tableProducts, product.toMap());
    return product.copyWith(id: id);
  }

  Future<List<Product>> getAllProduct() async {
    final db = await instance.database;
    final result = await db.query(tableProducts);

    return result.map((e) => Product.fromMap(e)).toList();
  }

  Future<int> saveOrder(OrderModel order) async {
    final db = await instance.database;
    int id = await db.insert('orders', order.toMapForLocal());
    for (var orderItem in order.orders) {
      await db.insert('order_items', orderItem.toMapForLocal(id));
      print(orderItem.toMapForLocal(id));
    }
    return id;
  }

  Future<List<OrderModel>> getOrderByIsSync() async {
    final db = await instance.database;
    final result = await db.query('orders', where: 'is_sync = 0');
    return result.map((e) => OrderModel.fromLocalMap(e)).toList();
  }

  Future<int?> getCountByIsSync() async {
    final db = await instance.database;
    final result = await db.query(
      'orders',
      where: 'is_sync = 0',
    );
    int rowCount = result.length;
    return rowCount;
  }

  Future<List<OrderItemKirim>> getOrderItemByOrderIdLocal(int idOrder) async {
    final db = await instance.database;
    final result = await db.query('order_items', where: 'id_order = $idOrder');

    return result.map((e) => OrderItem.fromMapLocal(e)).toList();
  }

  Future<List<OrderItem>> getOrderItemByOrderId(int idOrder) async {
    final db = await instance.database;
    final result = await db.query('order_items', where: 'id_order = $idOrder');

    return result.map((e) => OrderItem.fromMap(e)).toList();
  }

  Future<int> updateIsSyncOrderById(int id) async {
    final db = await instance.database;
    return await db.update('orders', {'is_sync': 1},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<List<OrderModel>> getAllOrder() async {
    final db = await instance.database;
    final result = await db.query('orders', orderBy: 'id DESC');

    return result.map((e) => OrderModel.fromLocalMap(e)).toList();
  }

  Future<bool> deleteSyncedOrdersAndItems() async {
    final db = await instance.database;

    // Step 1: Get orders with is_sync equal to 1
    final syncedOrders =
        await db.query('orders', where: 'is_sync = ?', whereArgs: [1]);

    // Step 2: Loop through and delete each order
    for (Map<String, dynamic> order in syncedOrders) {
      final orderId =
          order['id']; // Assuming 'id' is the primary key of 'orders' table

      // Step 3: Delete associated OrderItem records
      await _deleteOrderItemsByOrderId(db, orderId);

      // Step 4: Delete the order itself
      await db.delete('orders', where: 'id = ?', whereArgs: [orderId]);
    }
    print(syncedOrders);
    if (syncedOrders.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> _deleteOrderItemsByOrderId(Database db, int orderId) async {
    final orderItems = await db
        .query('order_items', where: 'id_order = ?', whereArgs: [orderId]);

    for (Map<String, dynamic> orderItem in orderItems) {
      final itemId = orderItem[
          'id']; // Assuming 'id' is the primary key of 'order_items' table
      await db.delete('order_items', where: 'id = ?', whereArgs: [itemId]);
    }
  }

  Future<List<Map<String, dynamic>>> getOrderItemsByOrderId(int orderId) async {
    final db = await instance.database;
    // final result = await db.rawQuery('''
    //   SELECT *
    //   FROM order_items
    //   WHERE id_order = ?
    // ''', [orderId]);
    final result = await db.rawQuery('''
    SELECT order_items.*, products.name
    FROM order_items
    INNER JOIN products ON order_items.id_product = products.product_id
    WHERE order_items.id_order = ?
  ''', [orderId]);
    print(result);
    return result;
  }
}
