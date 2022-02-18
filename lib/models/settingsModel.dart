// /* 数据模型 */
// import 'package:bp_notepad/db/settings_databaseProvider.dart';

// class SettingsDB {
//   int id;

//   String userName;

//   int height;

//   double weight;

//   int gender;

//   int age;

//   int isHypertension;

//   SettingsDB(
//       {this.id,
//       this.userName,
//       this.height,
//       this.weight,
//       this.gender,
//       this.age,
//       this.isHypertension});

//   Map<String, dynamic> toMap() {
//     var map = <String, dynamic>{
//       SettingsDatabaseProvider.COLUMN_ID: id,
//       SettingsDatabaseProvider.COLUMN_USERNAME: userName,
//       SettingsDatabaseProvider.COLUMN_HEIGHT: height,
//       SettingsDatabaseProvider.COLUMN_WEIGHT: weight,
//       SettingsDatabaseProvider.COLUMN_GENDER: gender,
//       SettingsDatabaseProvider.COLUMN_AGE: age,
//       SettingsDatabaseProvider.COLUMN_ISHYPERTENSION: isHypertension
//     };
//     if (id != null) {
//       map[SettingsDatabaseProvider.COLUMN_ID] = id;
//     }
//     return map;
//   }

//   SettingsDB.fromMap(Map<String, dynamic> map) {
//     id = map[SettingsDatabaseProvider.COLUMN_ID];
//     userName = map[SettingsDatabaseProvider.COLUMN_USERNAME];
//     height = map[SettingsDatabaseProvider.COLUMN_HEIGHT];
//     weight = map[SettingsDatabaseProvider.COLUMN_WEIGHT];
//     gender = map[SettingsDatabaseProvider.COLUMN_GENDER];
//     age = map[SettingsDatabaseProvider.COLUMN_AGE];
//     isHypertension = map[SettingsDatabaseProvider.COLUMN_ISHYPERTENSION];
//   }
// }
