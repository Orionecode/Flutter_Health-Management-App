import 'package:bp_notepad/models/alarmModel.dart';

// 记录了在界面的各种事件

abstract class ReminderEvent {}

// 初始化提醒列表
class SetAlarms extends ReminderEvent {
  List<AlarmDB> alarmList;

  SetAlarms(List<AlarmDB> alarms) {
    alarmList = alarms;
  }
}

// 删除提醒
class DeleteAlarm extends ReminderEvent {
  int alarmIndex;

  DeleteAlarm(int index) {
    alarmIndex = index;
  }
}

// 增加提醒
class AddAlarm extends ReminderEvent {
  AlarmDB newAlarm;

  AddAlarm(AlarmDB alarm) {
    newAlarm = alarm;
  }
}
