/* 新版历史记录查询界面，带日历 */
import 'package:bp_notepad/components/constants.dart';
import 'package:bp_notepad/db/alarm_databaseProvider.dart';
import 'package:bp_notepad/db/body_databaseProvider.dart';
import 'package:bp_notepad/db/bp_databaseProvider.dart';
import 'package:bp_notepad/db/bs_databaseProvider.dart';
import 'package:bp_notepad/db/sleep_databaseProvider.dart';
import 'package:bp_notepad/localization/appLocalization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:async/async.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with TickerProviderStateMixin {
  Map<DateTime, List<String>> _events = {};
  final _selectedDay = DateTime.now();
  late List<DateTime> _selectedEvents;
  AnimationController? _animationController;

  // CalendarController _calendarController;
  late AsyncMemoizer _memorizer;

  getDatabaseEvent() async {
    return this._memorizer.runOnce(() async {
      Future<List> bpEvents = BpDataBaseProvider.db.getData();
      Future<List> bsEvents = BsDataBaseProvider.db.getData();
      Future<List> bmiEvents = BodyDataBaseProvider.db.getData();
      Future<List> alarmEvents = AlarmDataBaseProvider.db.getData();
      Future<List> sleepEvents = SleepDataBaseProvider.db.getData();

      List bpList = await bpEvents;
      List bsList = await bsEvents;
      List bmiList = await bmiEvents;
      List alarmList = await alarmEvents;
      List sleepList = await sleepEvents;

      for (int index = 0; index < bpList.length; index++) {
        DateTime _unformattedDate =
            DateTime.parse(bpList[index].date); //先将数据库中读取到的数据保存在一个DateTime中
        DateTime _formattedDate = new DateTime(_unformattedDate.year,
            _unformattedDate.month, _unformattedDate.day); //格式化DateTime使其只保留年月日
        //使用update方法往Map中添加数据，如果读取到当天有数据=>增加，如果当天没有数据=>创建一个新的List
        _events.update(_formattedDate, (value) {
          value.add(
              "${bpList[index].date}\n${AppLocalization.of(context).translate('sys')}${bpList[index].sbp}mmHg\n${AppLocalization.of(context).translate('dia')}${bpList[index].dbp}mmHg\n${AppLocalization.of(context).translate('heart_rate')}: ${bpList[index].hr}${AppLocalization.of(context).translate('heart_rate_subtittle')}");
          return value;
        },
            ifAbsent: () => [
                  "${bpList[index].date}\n${AppLocalization.of(context).translate('sys')}${bpList[index].sbp}mmHg\n${AppLocalization.of(context).translate('dia')}${bpList[index].dbp}mmHg\n${AppLocalization.of(context).translate('heart_rate')}: ${bpList[index].hr}${AppLocalization.of(context).translate('heart_rate_subtittle')}"
                ]);
      }

      for (int index = 0; index < bsList.length; index++) {
        DateTime _unformattedDate = DateTime.parse(bsList[index].date);
        DateTime _formattedDate = new DateTime(_unformattedDate.year,
            _unformattedDate.month, _unformattedDate.day);
        _events.update(_formattedDate, (value) {
          value.add(
              "${bsList[index].date}\n${AppLocalization.of(context).translate('bs')} ${bsList[index].glu}mmol/L");
          return value;
        },
            ifAbsent: () => [
                  "${bsList[index].date}\n${AppLocalization.of(context).translate('bs')} ${bsList[index].glu}mmol/L"
                ]);
      }

      for (int index = 0; index < bmiList.length; index++) {
        DateTime _unformattedDate = DateTime.parse(bmiList[index].date);
        DateTime _formattedDate = new DateTime(_unformattedDate.year,
            _unformattedDate.month, _unformattedDate.day);
        _events.update(_formattedDate, (value) {
          value.add(
              "${bmiList[index].date}\n${AppLocalization.of(context).translate('weight')}: ${bmiList[index].weight}KG\n${AppLocalization.of(context).translate('bmi')}: ${bmiList[index].bmi}");
          return value;
        },
            ifAbsent: () => [
                  "${bmiList[index].date}\n${AppLocalization.of(context).translate('weight')}: ${bmiList[index].weight}KG\n${AppLocalization.of(context).translate('bmi')}: ${bmiList[index].bmi}"
                ]);
      }

      for (int index = 0; index < alarmList.length; index++) {
        DateTime _unformattedDate = DateTime.parse(alarmList[index].date);
        DateTime _formattedDate = new DateTime(_unformattedDate.year,
            _unformattedDate.month, _unformattedDate.day);
        _events.update(_formattedDate, (value) {
          value.add(
              "${alarmList[index].date}\n${AppLocalization.of(context).translate('alarm_textfield_tittle1')}: ${alarmList[index].medicine}\n${AppLocalization.of(context).translate('alarm_textfield_tittle2')}: ${alarmList[index].dosage}");
          return value;
        },
            ifAbsent: () => [
                  "${alarmList[index].date}\n${AppLocalization.of(context).translate('alarm_textfield_tittle1')}: ${alarmList[index].medicine}\n${AppLocalization.of(context).translate('alarm_textfield_tittle2')}: ${alarmList[index].dosage}"
                ]);
      }

      for (int index = 0; index < sleepList.length; index++) {
        DateTime _unformattedDate = DateTime.parse(sleepList[index].date);
        DateTime _formattedDate = new DateTime(_unformattedDate.year,
            _unformattedDate.month, _unformattedDate.day);
        _events.update(_formattedDate, (value) {
          value.add(
              "${sleepList[index].date}\n${AppLocalization.of(context).translate('sleep_input_title')}: ${sleepList[index].sleep}");
          return value;
        },
            ifAbsent: () => [
                  "${sleepList[index].date}\n${AppLocalization.of(context).translate('sleep_input_title')}: ${sleepList[index].sleep}"
                ]);
      }
      // print(_events);
      return _events;
    });
  }

  @override
  void initState() {
    super.initState();

    _memorizer = AsyncMemoizer();

    _selectedEvents =
        _events[_selectedDay]?.map((date) => DateTime.parse(date)).toList() ??
            [];

    // _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController?.forward();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    // _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(
    DateTime day,
    DateTime focusedDay,
  ) {
    // print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents.add(focusedDay);
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    // print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(PageController pageController) {
    // print('CALLBACK: _onCalendarCreated');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CupertinoPageScaffold(
        backgroundColor: CupertinoColors.systemGroupedBackground,
        child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                CupertinoSliverNavigationBar(
                    largeTitle: Text(
                        AppLocalization.of(context).translate('history_page'))),
              ];
            },
            body: FutureBuilder(
                future: getDatabaseEvent(),
                builder: (context, snapshot) {
                  return Column(
                    children: <Widget>[
                      TableCalendar(
                        firstDay: DateTime.utc(2020, 10, 16),
                        lastDay: DateTime.utc(2030, 3, 14),
                        focusedDay: DateTime.now(),
                        locale: 'en_US',
                        // calendarController: _calendarController,
                        // events: snapshot.data,
                        // initialCalendarFormat: CalendarFormat.month,
                        // formatAnimation: FormatAnimation.slide,
                        startingDayOfWeek: StartingDayOfWeek.sunday,
                        availableGestures: AvailableGestures.all,
                        availableCalendarFormats: const {
                          CalendarFormat.month: '',
                          CalendarFormat.week: '',
                        },
                        calendarStyle: CalendarStyle(
                          // selectedColor: CupertinoColors.systemRed,
                          // todayColor: Colors.red[200],
                          outsideDaysVisible: false,
                          // weekdayStyle: TextStyle().copyWith(
                          //     color: CupertinoDynamicColor.resolve(
                          //         textColor, context)),
                          // eventDayStyle: TextStyle().copyWith(
                          //     color: CupertinoDynamicColor.resolve(
                          //         textColor, context)),
                          // weekendStyle: TextStyle()
                          //     .copyWith(color: CupertinoColors.systemGrey),
                          // holidayStyle: TextStyle()
                          //     .copyWith(color: CupertinoColors.systemBlue),
                        ),
                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekendStyle: TextStyle()
                              .copyWith(color: CupertinoColors.systemBlue),
                        ),
                        headerStyle: HeaderStyle(
                          titleTextStyle: TextStyle().copyWith(
                              fontSize: 16,
                              color: CupertinoDynamicColor.resolve(
                                  textColor, context)),
                          // centerHeaderTitle: true,
                          formatButtonVisible: false,
                        ),
                        calendarBuilders: CalendarBuilders(
                          markerBuilder: (context, date, events) {
                            if (events.isNotEmpty) {
                              return Positioned(
                                right: 1,
                                bottom: 1,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: date == DateTime.now()
                                        ? Colors.red[200]
                                        : CupertinoColors.activeBlue,
                                  ),
                                  width: 20.0,
                                  height: 20.0,
                                  child: Center(
                                    child: Text(
                                      '${events.length}',
                                      style: TextStyle().copyWith(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                            return null;
                          },
                        ),
                        onDaySelected: (selectedDay, focusedDay) {
                          _onDaySelected(selectedDay, focusedDay);
                          _animationController?.forward(from: 0.0);
                        },
                        // onVisibleDaysChanged: _onVisibleDaysChanged,
                        onCalendarCreated: _onCalendarCreated,
                      ),
                      const SizedBox(height: 8.0),
                      Expanded(
                          child: MediaQuery.removePadding(
                              removeTop: true,
                              context: context,
                              child: Container(
                                  child: ListView(
                                children: _selectedEvents
                                    .map((event) => Container(
                                          child: Column(
                                            children: <Widget>[
                                              Card(
                                                color: CupertinoDynamicColor
                                                    .resolve(backGroundColor,
                                                        context),
                                                // elevation: 2.0, //Card的阴影
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                ),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 4.0),
                                                child: Container(
                                                  padding: EdgeInsets.all(12.0),
                                                  child: ListTile(
                                                    title: Text(
                                                      event.toString(),
                                                      style: TextStyle(
                                                          color:
                                                              CupertinoDynamicColor
                                                                  .resolve(
                                                                      textColor,
                                                                      context),
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    onTap: () =>
                                                        print('$event tapped!'),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ))
                                    .toList(),
                              )))),
                    ],
                  );
                })),
      ),
    );
  }
}
