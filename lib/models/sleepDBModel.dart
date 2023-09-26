/* 数据模型 */
import 'package:bp_notepad/db/sleep_databaseProvider.dart';

class SleepDB {
  int? id;
  double? sleep;
  int? state;
  String? date;

  SleepDB({this.id, this.sleep, this.state, this.date});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      SleepDataBaseProvider.COLUMN_ID: id,
      SleepDataBaseProvider.COLUMN_SLEEP: sleep,
      SleepDataBaseProvider.COLUMN_STATE: state,
      SleepDataBaseProvider.COLUMN_TIME: date
    };
    map[SleepDataBaseProvider.COLUMN_ID] = id;
      return map;
  }

  SleepDB.fromMap(Map<String, dynamic> map) {
    id = map[SleepDataBaseProvider.COLUMN_ID];
    sleep = map[SleepDataBaseProvider.COLUMN_SLEEP];
    state = map[SleepDataBaseProvider.COLUMN_STATE];
    date = map[SleepDataBaseProvider.COLUMN_TIME];
  }
}
