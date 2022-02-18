/* 选择什么内容进行记录的界面 */
import 'package:bp_notepad/localization/appLocalization.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bp_notepad/screens/FunctionScreen/bpScreen.dart';
import 'package:bp_notepad/screens/FunctionScreen/bsScreen.dart';
import 'package:flutter/material.dart';
import 'package:bp_notepad/screens/FunctionScreen/bmiScreen.dart';
import 'package:bp_notepad/components/constants.dart';

import 'FunctionScreen/sleepScreen.dart';


const List<Icon> icons = [
  const Icon(
    FontAwesomeIcons.heartbeat,
    color: const Color(0xFFFF284B),
  ),
  const Icon(
    FontAwesomeIcons.vial,
    color: const Color(0xFFFF4000),
  ),
  const Icon(
    FontAwesomeIcons.calculator,
    color: const Color(0xFF4E4CD0),
  ),
  const Icon(
    FontAwesomeIcons.bed,
    color: const Color(0xFF4E4CD0),
  ),
];

List<Widget> pageRoutes = [
  BloodPressure(),
  BloodSugar(),
  BmiScreen(),
  SleepScreen(),
];

class RecordMeun extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List tittleTexts = [
      AppLocalization.of(context).translate('bp_record'),
      AppLocalization.of(context).translate('bs_record'),
      AppLocalization.of(context).translate('bmi_Calc'),
      AppLocalization.of(context).translate('sleep_record'),
    ];
    return CupertinoPageScaffold(
      backgroundColor: CupertinoDynamicColor.resolve(
          CupertinoColors.systemGroupedBackground, context),
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            CupertinoSliverNavigationBar(
              largeTitle:
                  Text(AppLocalization.of(context).translate('record_tittle')),
            ),
          ];
        },
        body: MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: Container(
                padding: EdgeInsets.all(5.0),
                child: ListView.builder(
                  itemCount: pageRoutes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        child: Column(
                      children: <Widget>[
                        Card(
                            color: CupertinoDynamicColor.resolve(
                                backGroundColor, context),
                            // elevation: 4.0, //Card的阴影
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: ListTile(
                              leading: icons[index],
                              title: Text(tittleTexts[index],style: TextStyle(color: CupertinoDynamicColor.resolve(textColor, context),fontSize: 18),),
                              trailing:
                                  const Icon(CupertinoIcons.chevron_forward,color: Color(0xFF505054),),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            pageRoutes[index]));
                              },
                            ))
                      ],
                    ));
                  },
                ))),
      ),
    );
  }
}
