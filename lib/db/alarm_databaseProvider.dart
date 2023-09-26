/* 提醒事项数据库状态管理 与models中等数据模型alarmModels配合使用*/
import 'package:bp_notepad/models/alarmModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AlarmDataBaseProvider {
  // 列举了表名，列名等参数
  static const String TABLE_NAME = 'AlarmDB';
  static const String COLUMN_ID = "id";
  static const String COLUMN_DATE = 'date';
  static const String COLUMN_MEDICINE = 'medicine';
  static const String COLUMN_DOSAGE = 'dosage';
  static const String COLUMN_STATE = 'state';
  static const String COLUMN_PUSHID = "pushID";

  AlarmDataBaseProvider._();
  static final AlarmDataBaseProvider db = AlarmDataBaseProvider._();

  Database? _database;

  // Returns the database, generally no need to change
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await createDatabase();
    return _database!;
  }

  // 创建数据库参数，一般情况无需更改
  Future<Database> createDatabase() async {
    //Get the default databases location
    String dbPath = await getDatabasesPath();
    return await openDatabase(
      join(dbPath, 'alarmDB.db'),
      version: 1,
      onCreate: (Database database, int version) async {
        print('CREATING reminder table');
        await database.execute("CREATE TABLE $TABLE_NAME ("
            "$COLUMN_ID INTEGER PRIMARY KEY,"
            "$COLUMN_DATE TEXT,"
            "$COLUMN_MEDICINE TEXT,"
            "$COLUMN_DOSAGE TEXT,"
            "$COLUMN_STATE TEXT,"
            "$COLUMN_PUSHID INTEGER"
            ")");
      },
    );
  }

  // 读取数据库并返回
  Future<List<AlarmDB>> getData() async {
    final db = await database;

    var datas = await db.query(
      TABLE_NAME,
      columns: [
        COLUMN_ID,
        COLUMN_DATE,
        COLUMN_MEDICINE,
        COLUMN_DOSAGE,
        COLUMN_STATE,
        COLUMN_PUSHID,
      ],
    );

    List<AlarmDB> dataList = [];

    datas.forEach((element) {
      AlarmDB alarmDB = AlarmDB.fromMap(element);

      dataList.add(alarmDB);
    });

    return dataList; //逆置方便查看
  }

  // 读取数据库并返回
  Future<List> getNotification() async {
    final db = await database; //准备数据库
    var idList =
        await db.query(TABLE_NAME, columns: [COLUMN_ID]); //获取一个整个表ID的长度
    var datas = await db.query(
      TABLE_NAME,
      columns: [
        COLUMN_DATE,
        COLUMN_MEDICINE,
        COLUMN_DOSAGE,
        COLUMN_STATE,
      ],
      where: "id = ?",
      whereArgs: [idList.length],
    );

    List notificationData = [];
    datas.forEach((element) {
      AlarmDB alarmDB = AlarmDB.fromMap(element);
      notificationData.add(alarmDB.date);
      notificationData.add(alarmDB.state);
      notificationData.add(alarmDB.medicine);
      notificationData.add(alarmDB.dosage);
    });
    return notificationData;
  }

// 插入
  Future<AlarmDB> insert(AlarmDB alarmDB) async {
    final db = await database;
    alarmDB.id = await db.insert(TABLE_NAME, alarmDB.toMap());
    return alarmDB;
  }

// 删除
  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete(
      TABLE_NAME,
      where: "id = ?",
      whereArgs: [id],
    );
  }

// 更新
  Future<int> update(AlarmDB alarmDB) async {
    final db = await database;
    return await db.update(
      TABLE_NAME,
      alarmDB.toMap(),
      where: "id = ?",
      whereArgs: [alarmDB.id],
    );
  }
}
