/* 数据模型 */
import 'package:bp_notepad/db/alarm_databaseProvider.dart';

class AlarmDB {
  int id;
  int pushID;
  String date;
  String state;
  String medicine;
  String dosage;

  AlarmDB({
    this.id,
    this.state,
    this.date,
    this.medicine,
    this.dosage,
    this.pushID,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      AlarmDataBaseProvider.COLUMN_ID: id,
      AlarmDataBaseProvider.COLUMN_STATE: state,
      AlarmDataBaseProvider.COLUMN_DATE: date,
      AlarmDataBaseProvider.COLUMN_MEDICINE: medicine,
      AlarmDataBaseProvider.COLUMN_DOSAGE: dosage,
      AlarmDataBaseProvider.COLUMN_PUSHID: pushID,
    };
    if (id != null) {
      map[AlarmDataBaseProvider.COLUMN_ID] = id;
    }
    return map;
  }

  AlarmDB.fromMap(Map<String, dynamic> map) {
    id = map[AlarmDataBaseProvider.COLUMN_ID];
    state = map[AlarmDataBaseProvider.COLUMN_STATE];
    date = map[AlarmDataBaseProvider.COLUMN_DATE];
    medicine = map[AlarmDataBaseProvider.COLUMN_MEDICINE];
    dosage = map[AlarmDataBaseProvider.COLUMN_DOSAGE];
    pushID = map[AlarmDataBaseProvider.COLUMN_PUSHID];
  }
}
