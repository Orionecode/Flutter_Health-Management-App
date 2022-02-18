/* 数据模型 */
import 'package:bp_notepad/db/bs_databaseProvider.dart';

class BloodSugarDB {
  int id;
  double glu;
  int state;
  String date;

  BloodSugarDB({this.id, this.glu, this.state, this.date});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      BsDataBaseProvider.COLUMN_ID: id,
      BsDataBaseProvider.COLUMN_GLU: glu,
      BsDataBaseProvider.COLUMN_STATE: state,
      BsDataBaseProvider.COLUMN_TIME: date
    };
    if (id != null) {
      map[BsDataBaseProvider.COLUMN_ID] = id;
    }
    return map;
  }

  BloodSugarDB.fromMap(Map<String, dynamic> map) {
    id = map[BsDataBaseProvider.COLUMN_ID];
    glu = map[BsDataBaseProvider.COLUMN_GLU];
    state = map[BsDataBaseProvider.COLUMN_STATE];
    date = map[BsDataBaseProvider.COLUMN_TIME];
  }
}
