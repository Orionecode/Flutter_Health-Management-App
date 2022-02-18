/* 血糖事项数据库状态管理 与models中等数据模型bpDBModel配合使用*/
import 'package:bp_notepad/models/sleepDBModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SleepDataBaseProvider {
  static const String TABLE_NAME = 'sleepDB';
  static const String COLUMN_ID = "id";
  static const String COLUMN_TIME = 'date';
  static const String COLUMN_SLEEP = 'sleep';
  static const String COLUMN_STATE = 'state';

  SleepDataBaseProvider._();
  static final SleepDataBaseProvider db = SleepDataBaseProvider._();

  Database _database;

  //get database在flutter中为getter的写法
  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await createDatabase();
    return _database;
  }

  Future<Database> createDatabase() async {
    //Get the default databases location
    String dbPath = await getDatabasesPath();
    return await openDatabase(
      join(dbPath, 'sleepDB.db'),
      version: 1,
      onCreate: (Database database, int version) async {
        print('CREATING sleepDB table');
        await database.execute("CREATE TABLE $TABLE_NAME ("
            "$COLUMN_ID INTEGER PRIMARY KEY,"
            "$COLUMN_TIME TEXT,"
            "$COLUMN_SLEEP REAL,"
            "$COLUMN_STATE INTEGER"
            ")");
      },
    );
  }

  Future<List> getGraphData() async {
    List dataList = [];
    final db = await database;
    var datas = await db.query(
      TABLE_NAME,
      columns: [COLUMN_SLEEP],
    );
    datas.forEach((element) {
      SleepDB sleepDB = SleepDB.fromMap(element);
      dataList.add(sleepDB.sleep);
    });
    return dataList;
  }

  Future<List<SleepDB>> getData() async {
    final db = await database;

    var datas = await db.query(
      TABLE_NAME,
      columns: [COLUMN_ID, COLUMN_TIME, COLUMN_SLEEP, COLUMN_STATE],
    );

    List<SleepDB> dataList = [];

    datas.forEach((element) {
      SleepDB sleepDB = SleepDB.fromMap(element);

      dataList.add(sleepDB);
    });

    return dataList.reversed.toList(); //逆置List方便查看
  }

  Future<SleepDB> insert(SleepDB sleepDB) async {
    final db = await database;
    sleepDB.id = await db.insert(TABLE_NAME, sleepDB.toMap());
    return sleepDB;
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
