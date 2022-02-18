// /* 数据库状态管理 与models中数据模型配合使用*/
// import 'package:bp_notepad/models/settingsModel.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class SettingsDatabaseProvider {
//   static const String TABLE_NAME = 'settingsDB';
//   static const String COLUMN_ID = "id";
//   static const String COLUMN_USERNAME = 'userName';
//   static const String COLUMN_GENDER = 'gender';
//   static const String COLUMN_HEIGHT = 'height';
//   static const String COLUMN_WEIGHT = 'weight';
//   static const String COLUMN_AGE = 'age';
//   static const String COLUMN_ISHYPERTENSION = 'isHypertension';

//   SettingsDatabaseProvider._();
//   static final SettingsDatabaseProvider db = SettingsDatabaseProvider._();

//   Database _database;

//   //get database在flutter中为getter的写法
//   Future<Database> get database async {
//     if (_database != null) {
//       return _database;
//     }
//     _database = await createDatabase();
//     return _database;
//   }

//   Future<Database> createDatabase() async {
//     //Get the default databases location
//     String dbPath = await getDatabasesPath();
//     return await openDatabase(
//       join(dbPath, 'settings.db'),
//       version: 1,
//       onCreate: (Database database, int version) async {
//         print('CREATING settingsDB table');
//         //下面一定要注意每句SQL语句后面必须加上逗号
//         await database.execute("CREATE TABLE $TABLE_NAME ("
//             "$COLUMN_ID INTEGER PRIMARY KEY,"
//             "$COLUMN_USERNAME TEXT,"
//             "$COLUMN_GENDER INTEGER,"
//             "$COLUMN_HEIGHT INTEGER,"
//             "$COLUMN_WEIGHT REAL,"
//             "$COLUMN_AGE INTEGER,"
//             "$COLUMN_ISHYPERTENSION INTEGER"
//             ")");
//       },
//     );
//   }

// //请求返回数据，类型为List

//   Future<List<SettingsDB>> getData() async {
//     final db = await database;

//     var datas = await db.query(
//       TABLE_NAME,
//       columns: [
//         COLUMN_ID,
//         COLUMN_USERNAME,
//         COLUMN_GENDER,
//         COLUMN_HEIGHT,
//         COLUMN_WEIGHT,
//         COLUMN_AGE,
//         COLUMN_ISHYPERTENSION
//       ],
//     );

//     List<SettingsDB> dataList = [];

//     datas.forEach((element) {
//       SettingsDB settingsDB = SettingsDB.fromMap(element);

//       dataList.add(settingsDB);
//     });

//     return dataList.reversed.toList(); //逆置List方便查看
//   }

// // 插入数据，需要先在settingsDBModel中格式化
//   Future<SettingsDB> insert(SettingsDB settingsDB) async {
//     final db = await database;
//     if (settingsDB.id == 0) {
//       settingsDB.id = await db.insert(TABLE_NAME, settingsDB.toMap());
//       return settingsDB;
//     } else {
//       delete(0);
//       settingsDB.id = await db.insert(TABLE_NAME, settingsDB.toMap());
//       return settingsDB;
//     }
//   }

// // 删除数据
//   Future<int> delete(int id) async {
//     final db = await database;
//     return await db.delete(
//       TABLE_NAME,
//       where: "id = ?",
//       whereArgs: [id],
//     );
//   }
// }

// // SQLite具有以下五种数据类型：
// // 1.NULL：空值。
// // 2.INTEGER：带符号的整型，具体取决有存入数字的范围大小。
// // 3.REAL：浮点数字，存储为8-byte IEEE浮点数。
// // 4.TEXT：字符串文本。
// // 5.BLOB：二进制对象。
