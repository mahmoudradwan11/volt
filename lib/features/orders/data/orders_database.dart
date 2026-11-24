import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:volt/features/orders/models/order_model.dart';

/// Local on-device store for orders (sqflite).
///
/// Orders are saved per customer: every row carries the customer's
/// nationalId, and reads are filtered by it, so each customer on the
/// device only ever sees their own orders.
class OrdersDatabase {
  OrdersDatabase._();
  static final OrdersDatabase instance = OrdersDatabase._();

  static const String _dbName = 'volt_orders.db';
  static const String ordersTable = 'orders';
  static const String orderItemsTable = 'order_items';

  Database? _db;

  Future<Database> get database async {
    _db ??= await openDatabase(
      join(await getDatabasesPath(), _dbName),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $ordersTable (
            id TEXT PRIMARY KEY,
            nationalId TEXT NOT NULL,
            createdAt TEXT NOT NULL,
            status TEXT,
            paymentMethod TEXT,
            totalPaid REAL
          )
        ''');
        await db.execute('''
          CREATE TABLE $orderItemsTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            orderId TEXT NOT NULL,
            productId TEXT,
            name TEXT,
            company TEXT,
            image TEXT,
            price REAL,
            quantity INTEGER
          )
        ''');
      },
    );
    return _db!;
  }

  /// Saves an order with its items. Call this from the checkout flow
  /// once an order is placed.
  Future<void> insertOrder(Order order) async {
    final db = await database;
    await db.insert(
      ordersTable,
      order.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    for (final item in order.items ?? <OrderItem>[]) {
      await db.insert(orderItemsTable, item.toMap(order.sId!));
    }
  }

  /// All orders of one customer, newest first, with their items.
  Future<List<Order>> getOrders(String nationalId) async {
    final db = await database;
    final orderRows = await db.query(
      ordersTable,
      where: 'nationalId = ?',
      whereArgs: [nationalId],
      orderBy: 'createdAt DESC',
    );
    final orders = <Order>[];
    for (final row in orderRows) {
      final order = Order.fromMap(row);
      final itemRows = await db.query(
        orderItemsTable,
        where: 'orderId = ?',
        whereArgs: [order.sId],
      );
      order.items = itemRows.map((e) => OrderItem.fromMap(e)).toList();
      orders.add(order);
    }
    return orders;
  }

  Future<void> deleteOrder(String orderId) async {
    final db = await database;
    await db.delete(ordersTable, where: 'id = ?', whereArgs: [orderId]);
    await db
        .delete(orderItemsTable, where: 'orderId = ?', whereArgs: [orderId]);
  }
}
