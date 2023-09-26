/* 提醒用药的卡片界面 */
import 'package:bp_notepad/db/alarm_databaseProvider.dart';
import 'package:bp_notepad/events/reminderBloc.dart';
import 'package:bp_notepad/events/reminderEvent.dart';
import 'package:bp_notepad/localization/appLocalization.dart';
import 'package:bp_notepad/models/alarmModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bp_notepad/components/constants.dart';
import 'FunctionScreen/ocrScreen.dart';

List<Icon> icons = [
  Icon(
    FontAwesomeIcons.mugHot,
    color: CupertinoColors.systemTeal,
  ),
  Icon(
    FontAwesomeIcons.syringe,
    color: CupertinoColors.systemIndigo,
  ),
  Icon(
    FontAwesomeIcons.child,
    color: CupertinoColors.systemPurple,
  ),
  Icon(
    FontAwesomeIcons.pills,
    color: CupertinoColors.systemPink,
  ),
];

late Icon _iconState; //切换图标的显示

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({Key? key}) : super(key: key);

  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin; //声明一个本地提醒的插件

  @override
  void initState() {
    super.initState();
    AlarmDataBaseProvider.db.getData().then(
      (alarmList) {
        BlocProvider.of<ReminderBloc>(context).add(SetAlarms(alarmList));
      },
    );

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS =
    DarwinInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initSettings = new InitializationSettings(android: android, iOS: iOS);
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }
  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {

    // Handle notification received
    debugPrint("Notification Received: $payload");

  }

  // ignore: missing_return
  Future onDidReceiveNotificationResponse(NotificationResponse response) async {

    // Get payload from response
    String? payload = response.payload;

    // Handle response
    debugPrint("payload : $payload");
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Notification'),
        content: Text('$payload'),
      ),
    );
  }

  // 取消通知
  Future<void> cancelNotification(int index) async {
    await flutterLocalNotificationsPlugin.cancel(index);
  }

  Future<void> _handleClickMe(
      BuildContext context, int index, AlarmDB alarm) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
            title: Text(
              '${alarm.date}',
            ),
            content: Text(
              '${AppLocalization.of(context).translate('double_check')}?\n${AppLocalization.of(context).translate('oral_administration')}:${alarm.medicine}\n${AppLocalization.of(context).translate('dosage')}:${alarm.dosage}',
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () =>
                    AlarmDataBaseProvider.db.delete(alarm.id!).then((_) {
                  BlocProvider.of<ReminderBloc>(context).add(
                    DeleteAlarm(index),
                  );
                  cancelNotification(alarm.pushID!);
                  Navigator.pop(context);
                }),
                child: Text(AppLocalization.of(context).translate('delete')),
              ),
              CupertinoDialogAction(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalization.of(context).translate('cancel')))
            ]);
      },
    );
  }

  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.systemGroupedBackground,
        child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                CupertinoSliverNavigationBar(
                  largeTitle: Text(
                      AppLocalization.of(context).translate('reminder_tittle')),
                  trailing: TextButton(
                    child: Text(
                      AppLocalization.of(context).translate('floating_text'),
                      style: TextStyle(color: CupertinoColors.systemBlue),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (BuildContext context) => OCRDetect()),
                    ),
                  ),
                ),
              ];
            },
            body: MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: Container(
                padding: EdgeInsets.all(5.0),
                child: BlocConsumer<ReminderBloc, List<AlarmDB>>(
                  builder: (context, alarmList) {
                    return ListView.builder(
                      itemCount: alarmList.length,
                      itemBuilder: (BuildContext context, int index) {
                        AlarmDB alarm = alarmList[index];
                        if (alarm.state == '口服') {
                          _iconState = icons[0];
                        } else if (alarm.state == '注射') {
                          _iconState = icons[1];
                        } else if (alarm.state == '外用') {
                          _iconState = icons[2];
                        } else {
                          _iconState = icons[3];
                        }
                        return Card(
                          color: CupertinoDynamicColor.resolve(
                              backGroundColor, context),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          // color: const Color(0xFF1D1E33),
                          child: ListTile(
                            isThreeLine: true,
                            contentPadding: EdgeInsets.all(16),
                            title: Text("${alarm.medicine}",
                                style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: CupertinoDynamicColor.resolve(
                                        textColor, context))),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${AppLocalization.of(context).translate('date')}: ${alarm.date}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: CupertinoDynamicColor.resolve(
                                          textColor, context)),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  "${AppLocalization.of(context).translate('dosage')}: ${alarm.dosage}\n${AppLocalization.of(context).translate('usage')}: ${alarm.state}",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: CupertinoDynamicColor.resolve(
                                          textColor, context)),
                                ),
                              ],
                            ),
                            trailing: _iconState,
                            onLongPress: () => {
                              _handleClickMe(context, index, alarm),
                            },
                          ),
                        );
                      },
                    );
                  },
                  listener: (BuildContext context, alarmList) {},
                ),
              ),
            )));
  }
}
