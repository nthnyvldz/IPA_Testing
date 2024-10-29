import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('results.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    print('Database path: $path'); // Print the database path to console

    return await openDatabase(
      path,
      version: 4,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    const batchNumberType = 'INTEGER PRIMARY KEY';
    const countType = 'INTEGER NOT NULL';

    await db.execute('''
      CREATE TABLE results (
        batch_number $batchNumberType,
        total_count $countType
      )
    ''');

    await db.execute('''
      CREATE TABLE sales (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        batch_number INTEGER,
        total_count INTEGER,
        price_sold TEXT,
        date_sold TEXT,
        FOREIGN KEY (batch_number) REFERENCES results(batch_number)
      )
    ''');
  }

  Future<int> insertResult(Map<String, dynamic> result) async {
    final db = await instance.database;
    return await db.insert('results', result);
  }

  Future<int> insertSale(Map<String, dynamic> sale) async {
    final db = await instance.database;
    return await db.insert('sales', sale);
  }

  Future<int> updateSale(Map<String, dynamic> sale) async {
    final db = await instance.database;
    int id = sale['id'];
    return await db.update(
      'sales',
      sale,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteSale(int id) async {
    final db = await instance.database;
    return await db.delete(
      'sales',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteResult(int batchNumber) async {
    final db = await database;
    return await db.delete(
      'results', // The table name
      where: 'batch_number = ?', // The condition for the deletion
      whereArgs: [batchNumber],
    );
  }

  Future<List<Map<String, dynamic>>> fetchResults() async {
    final db = await instance.database;
    return await db.query('results');
  }

  Future<Map<String, dynamic>?> getBatchByNumber(int batchNumber) async {
    final db = await database;
    var result = await db.query(
      'results', // Assuming your table name is 'results'
      where: 'batch_number = ?',
      whereArgs: [batchNumber],
      limit: 1,
    );

    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> fetchSales() async {
    final db = await instance.database;
    return await db.query('sales');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
