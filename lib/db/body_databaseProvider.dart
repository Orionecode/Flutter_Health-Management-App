/* BMI数据库状态管理 与models中等数据模型bmiModel配合使用*/

import 'package:bp_notepad/models/bodyModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BodyDataBaseProvider {
  static const String TABLE_NAME = 'bloodpressureDB';
  static const String COLUMN_ID = "id";
  static const String COLUMN_TIME = 'date';
  static const String COLUMN_BMI = 'bmi';
  static const String COLUMN_BF = 'bf';
  static const String COLUMN_WEIGHT = 'weight';
  static const String COLUMN_GENDER = 'gender';

  BodyDataBaseProvider._();
  static final BodyDataBaseProvider db = BodyDataBaseProvider._();

  Database? _database;

  // Returns the database, generally no need to change
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await createDatabase();
    return _database!;
  }

  Future<Database> createDatabase() async {
    //Get the default databases location
    String dbPath = await getDatabasesPath();
    return await openDatabase(
      join(dbPath, 'bmiDB.db'),
      version: 1,
      onCreate: (Database database, int version) async {
        print('CREATING bodyDB table');
        await database.execute("CREATE TABLE $TABLE_NAME ("
            "$COLUMN_ID INTEGER PRIMARY KEY,"
            "$COLUMN_TIME TEXT,"
            "$COLUMN_BMI REAL,"
            "$COLUMN_BF REAL,"
            "$COLUMN_WEIGHT REAL,"
            "$COLUMN_GENDER INTEGER"
            ")");
      },
    );
  }

  Future checkFirstLogin() async {
    final db = await database;
    var datas = await db.query(TABLE_NAME, columns: [COLUMN_ID]);
    return datas;
  }

  Future<List> getGraphData() async {
    List bmiDataList = [];
    final db = await database;
    var datas = await db.query(TABLE_NAME, columns: [COLUMN_BMI]);
    datas.forEach((element) {
      BodyDB bmiDB = BodyDB.fromMap(element);
      bmiDataList.add(bmiDB.bmi);
    });
    return bmiDataList;
  }

  Future<List<BodyDB>> getData() async {
    final db = await database;

    var datas = await db.query(
      TABLE_NAME,
      columns: [
        COLUMN_ID,
        COLUMN_TIME,
        COLUMN_BMI,
        COLUMN_BF,
        COLUMN_WEIGHT,
        COLUMN_GENDER
      ],
    );

    List<BodyDB> dataList = [];

    datas.forEach((element) {
      BodyDB bmiDB = BodyDB.fromMap(element);

      dataList.add(bmiDB);
    });

    return dataList.reversed.toList(); //逆置List方便查看
  }

  Future<BodyDB> insert(BodyDB bmiDB) async {
    final db = await database;
    bmiDB.id = await db.insert(TABLE_NAME, bmiDB.toMap());
    return bmiDB;
  }

  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete(
      TABLE_NAME,
      where: "id = ?",
      whereArgs: [id],
    );
  }
}

// SQLite具有以下五种数据类型：
// 1.NULL：空值。
// 2.INTEGER：带符号的整型，具体取决有存入数字的范围大小。
// 3.REAL：浮点数字，存储为8-byte IEEE浮点数。
// 4.TEXT：字符串文本。
// 5.BLOB：二进制对象。
