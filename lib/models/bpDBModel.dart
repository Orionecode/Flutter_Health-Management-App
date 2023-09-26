/* 数据模型 */
import 'package:bp_notepad/db/bp_databaseProvider.dart';

class BloodPressureDB {
  int? id;
  int? sbp;
  int? dbp;
  int? hr;
  int? state;
  String? date;

  BloodPressureDB({this.sbp, this.dbp, this.hr, this.state, this.date});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      BpDataBaseProvider.COLUMN_ID: id,
      BpDataBaseProvider.COLUMN_SBP: sbp,
      BpDataBaseProvider.COLUMN_DBP: dbp,
      BpDataBaseProvider.COLUMN_HR: hr,
      BpDataBaseProvider.COLUMN_TIME: date,
      BpDataBaseProvider.COLUMN_STATE: state,
    };
    map[BpDataBaseProvider.COLUMN_ID] = id;
      return map;
  }

  BloodPressureDB.fromMap(Map<String, dynamic> map) {
    id = map[BpDataBaseProvider.COLUMN_ID];
    sbp = map[BpDataBaseProvider.COLUMN_SBP];
    dbp = map[BpDataBaseProvider.COLUMN_DBP];
    hr = map[BpDataBaseProvider.COLUMN_HR];
    state = map[BpDataBaseProvider.COLUMN_STATE];
    date = map[BpDataBaseProvider.COLUMN_TIME];
  }
}
