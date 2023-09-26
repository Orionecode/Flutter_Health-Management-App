/* 添加提醒用药界面 */
import 'dart:math';
import 'package:bp_notepad/components/buttonButton.dart';
import 'package:bp_notepad/components/resusableCard.dart';
import 'package:bp_notepad/db/alarm_databaseProvider.dart';
import 'package:bp_notepad/events/reminderBloc.dart';
import 'package:bp_notepad/events/reminderEvent.dart';
import 'package:bp_notepad/localization/appLocalization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bp_notepad/components/constants.dart';
import 'package:bp_notepad/models/alarmModel.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:intl/intl.dart';

class AlarmScreen extends StatefulWidget {
  final String? initialMedicineTitle;
  final String? initialMedicineDosage;
  final String? initialMedicineUsage;

  const AlarmScreen({
    Key? key,
    this.initialMedicineTitle,
    this.initialMedicineDosage,
    this.initialMedicineUsage,
  }) : super(key: key);
  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  int _pushID = Random().nextInt(10000000); //生成一个随机数用于通知的ID和通道ID
  DateTime _selectedDate = DateTime.now(); //获取一个当前的日期
  String _formattedDate =
      DateFormat('yyyy-MM-dd kk:mm').format(DateTime.now()); //获取一个格式化后的当前日期
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin; //声明一个本地提醒的插件
  final TextEditingController _textEditingController = TextEditingController();
  late TextEditingController _medicineInput;
  late TextEditingController _dosageInput;
  late TextEditingController _usageInput;

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  // TextField的控制器,用来获取输入的值
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _medicine = '';
  String _dosage = '';
  String _usage = '';

  List<bool> _selections = List.generate(4, (_) => false);

// 初始化通知插件
  void initState() {
    super.initState();
    _medicineInput = TextEditingController(text: widget.initialMedicineTitle);
    _dosageInput = TextEditingController(text: widget.initialMedicineDosage);
    _usageInput = TextEditingController(text: widget.initialMedicineUsage);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS =
    DarwinInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    var initSetttings = new InitializationSettings(android: android, iOS: iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

  }

  // ignore: missing_return
  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {

    // Handle notification received
    debugPrint("Notification Received: $payload");

  }

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

  // 通知推送组件
  _showNotification() async {
    // 组合一个新的DateTime
    final datetime = new DateTime(_selectedDate.year, _selectedDate.month,
        _selectedDate.day, _selectedDate.hour, _selectedDate.minute);
    // 获取通知日期，时间，内容
    List alarmList = await AlarmDataBaseProvider.db.getNotification();
    // 使用flutter_native_timezone 获取当前时区
    final String currentTimeZone =
        await FlutterNativeTimezone.getLocalTimezone();
    print(currentTimeZone);
    // 时区必须初始化,初始化之后才可以使用
    tz.initializeTimeZones();
    // 设置时区
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
    // 将DateTime日期转换为TZDatetime
    final notiDate =
        new tz.TZDateTime.from(datetime, tz.getLocation(currentTimeZone));
    // 设置安卓的提醒内容和通道
    var android = new AndroidNotificationDetails(
        'Reminder_Channel$_pushID',
        'Medication reminders',
        channelDescription: 'Reminder to take medication at the time you specify',
        priority: Priority.high,
        importance: Importance.max);
    // IOS设备
    var iOS = new DarwinNotificationDetails(threadIdentifier: "thread_id");
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.zonedSchedule(
        _pushID,
        AppLocalization.of(context).translate('noti_medicine_remind'),
        '${alarmList[1]}:${alarmList[2]}\n${AppLocalization.of(context).translate('dosage')}:${alarmList[3]}',
        notiDate,
        platform,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exact);
    print(_pushID);
  }

  _selectDate() async {
    DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      backgroundColor: CupertinoDynamicColor.resolve(modalGroundColor, context),
      context: context,
      builder: (context) {
        DateTime? tempPickedDate;
        return Container(
          height: 350,
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButton(
                      child:
                          Text(AppLocalization.of(context).translate('cancel')),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    CupertinoButton(
                      child:
                          Text(AppLocalization.of(context).translate('done')),
                      onPressed: () {
                        Navigator.of(context).pop(tempPickedDate);
                      },
                    ),
                  ],
                ),
              ),
              Divider(
                height: 0,
                thickness: 1,
              ),
              Expanded(
                child: Container(
                  child: CupertinoDatePicker(
                    backgroundColor: CupertinoDynamicColor.resolve(
                        modalGroundColor, context),
                    use24hFormat: true,
                    mode: CupertinoDatePickerMode.dateAndTime,
                    minimumYear: _selectedDate.year,
                    onDateTimeChanged: (DateTime dateTime) {
                      tempPickedDate = dateTime;
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    if (pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate!;
        _textEditingController.text = pickedDate.toString();
        _formattedDate = DateFormat('yyyy-MM-dd kk:mm').format(_selectedDate);
      });
    }
  }

  Widget _medicineTextField() {
    return CupertinoTextField(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0)), //,
      controller: _medicineInput,
      maxLines: 3,
      placeholder:
          AppLocalization.of(context).translate('alarm_textfield_tittle1'),
      onChanged: (String value) {
        _medicine = value;
      },
    );
  }

  Widget _dosageTextField() {
    return CupertinoTextField(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
      controller: _dosageInput,
      maxLines: 3,
      placeholder:
          AppLocalization.of(context).translate('alarm_textfield_tittle2'),
      onChanged: (String value) {
        _dosage = value;
      },
    );
  }

  Widget _usageTextField() {
    return CupertinoTextField(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
      controller: _usageInput,
      maxLines: 3,
      placeholder:
          AppLocalization.of(context).translate('alarm_textfield_tittle3'),
      onChanged: (String value) {
        _usage = value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CupertinoPageScaffold(
          backgroundColor: CupertinoColors.systemGroupedBackground,
          navigationBar: CupertinoNavigationBar(
            middle: Text(
              AppLocalization.of(context).translate('alarm_newalarm'),
            ),
            backgroundColor:
                CupertinoTheme.of(context).barBackgroundColor.withOpacity(1.0),
          ),
          child: Form(
              key: _formKey,
              child: Container(
                  child: SingleChildScrollView(
                      padding: EdgeInsets.all(5.0),
                      child: ConstrainedBox(
                          constraints:
                              BoxConstraints(maxWidth: double.infinity),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                        height: 140,
                                        child: GestureDetector(
                                          onTap: () {
                                            _selectDate();
                                          },
                                          child: ReusableCard(
                                              color:
                                                  CupertinoDynamicColor.resolve(
                                                      backGroundColor, context),
                                              cardChild: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(FontAwesomeIcons.clock,
                                                      size: 60),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                      "${AppLocalization.of(context).translate('time_remind_front')} $_formattedDate",
                                                      style:
                                                          kLargeLableTextStyle),
                                                ],
                                              )),
                                        )),
                                  ),
                                ],
                              ),
                              Container(
                                child: ReusableCard(
                                  cardChild: _medicineTextField(),
                                  color: CupertinoDynamicColor.resolve(
                                      backGroundColor, context),
                                ),
                              ),
                              Container(
                                child: ReusableCard(
                                  cardChild: _dosageTextField(),
                                  color: CupertinoDynamicColor.resolve(
                                      backGroundColor, context),
                                ),
                              ),
                              Container(
                                child: ReusableCard(
                                  cardChild: _usageTextField(),
                                  color: CupertinoDynamicColor.resolve(
                                      backGroundColor, context),
                                ),
                              ),
                              ButtonButton(
                                onTap: () {
                                  _formKey.currentState?.save();
                                  if (_medicine != '') {
                                    _medicineInput.text = _medicine;
                                  }
                                  if (_dosage != '') {
                                    _dosageInput.text = _dosage;
                                  }
                                  if (_usage != '') {
                                    _usageInput.text = _usage;
                                  }
                                  AlarmDB alarmDB = AlarmDB(
                                    date: _formattedDate,
                                    medicine: _medicineInput.text,
                                    dosage: _dosageInput.text,
                                    state: _usageInput.text,
                                    pushID: _pushID,
                                  );
                                  AlarmDataBaseProvider.db.insert(alarmDB).then(
                                      (value) =>
                                          BlocProvider.of<ReminderBloc>(context)
                                              .add(AddAlarm(value)));

                                  _showNotification();
                                  int count = 0; //这里需要返回到前两个界面，所以要pop两次
                                  Navigator.popUntil(
                                      context, (route) => count++ >= 3);
                                },
                                buttonTitle: AppLocalization.of(context)
                                    .translate('alarm_confirm_button'),
                              ),
                              const SizedBox(
                                height: 80,
                              ),
                            ],
                          )))))),
    );
  }
}
