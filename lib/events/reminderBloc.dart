/* BlockProvider，用于动态刷新列表 */
import 'package:bp_notepad/events/reminderEvent.dart';
import 'package:bp_notepad/models/alarmModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReminderBloc extends Bloc<ReminderEvent, List<AlarmDB>> {

  ReminderBloc() : super([]);

  // ReminderBloc(List<AlarmDB> initialState) : super(initialState);

  // 初始化一个AlarmDB列表
  List<AlarmDB> get initialState => [];

  Stream<List<AlarmDB>> mapEventToState(ReminderEvent event) async* {
    if (event is SetAlarms) {
      yield event.alarmList;
    } else if (event is AddAlarm) {
      List<AlarmDB> newState = List.from(state);
      newState.add(event.newAlarm);
          yield newState;
    } else if (event is DeleteAlarm) {
      List<AlarmDB> newState = List.from(state);
      newState.removeAt(event.alarmIndex);
      yield newState;
    }
  }
}
