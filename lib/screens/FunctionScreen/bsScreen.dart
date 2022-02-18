/* 添加血糖记录界面 */
import 'package:bp_notepad/components/iconContent.dart';
import 'package:bp_notepad/components/resusableCard.dart';
import 'package:bp_notepad/components/buttomButton.dart';
import 'package:bp_notepad/components/constants.dart';
import 'package:bp_notepad/db/bs_databaseProvider.dart';
import 'package:bp_notepad/localization/appLocalization.dart';
import 'package:bp_notepad/models/bsDBModel.dart';
import 'package:bp_notepad/screens/ResultScreen/bsResultScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

bool flag = true;

enum Meal {
  beforeMeal,
  afterMeal,
}

class BloodSugar extends StatefulWidget {
  @override
  _BloodSugarState createState() => _BloodSugarState();
}

class _BloodSugarState extends State<BloodSugar> {
  double glU = 4.0; //血糖
  int _selectedGluInt = 4;
  int _selectedGluFloat = 0;

  TextEditingController _voiceInputController;
  String _voiceInput = '';

  List checkBS(String text) {
    List<dynamic> bsData = [];
    if (text.contains("前")) {
      bsData.add(0);
      RegExp c = new RegExp(r'([0-9]{1,2}?)+(\.[0-9]{1,2})');
      Iterable<Match> matches = c.allMatches(text);
      for (Match m in matches) {
        double match = double.parse(m[0]);
        bsData.add(match);
      }
    } else if (text.contains("后")) {
      bsData.add(1);
      RegExp c = new RegExp(r'([0-9]{1,2}?)+(\.[0-9]{1,2})');
      Iterable<Match> matches = c.allMatches(text);
      for (Match m in matches) {
        double match = double.parse(m[0]);
        bsData.add(match);
      }
    }
    if (bsData.length == 2) {
      bsData.insert(0, true);
      return bsData;
    } else {
      bsData.insert(0, false);
      return bsData;
    }
  }

  Widget _voiceInputTextField() {
    return CupertinoTextField(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0)), //,
      controller: _voiceInputController,
      maxLines: 4,
      placeholder:
          AppLocalization.of(context).translate('bs_screen_textfield_title'),
      onChanged: (String value) {
        _voiceInput = value;
      },
    );
  }

  Meal selectedMeal;
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        middle: Text(AppLocalization.of(context).translate('input_statistics')),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(5),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: double.infinity),
            child: Column(
              children: <Widget>[
                Container(
                  child: ReusableCard(
                    cardChild: _voiceInputTextField(),
                    color:
                        CupertinoDynamicColor.resolve(backGroundColor, context),
                  ),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: ReusableCard(
                        onPressed: () {
                          setState(() {
                            HapticFeedback.mediumImpact();
                            selectedMeal = Meal.beforeMeal;
                          });
                        },
                        color: selectedMeal == Meal.beforeMeal
                            ? kActiveCardColour
                            : CupertinoDynamicColor.resolve(
                                backGroundColor, context),
                        cardChild: IconFont(
                          icon: CupertinoIcons.battery_25,
                          lable: AppLocalization.of(context)
                              .translate('before_meal_state'),
                          textStyle: selectedMeal == Meal.beforeMeal
                              ? kSelctedTextStyle
                              : kLabelTextStyle,
                          colorStyle: selectedMeal == Meal.beforeMeal
                              ? const Color(0xFFFFFFFF)
                              : const Color(0xFFDFDDF0),
                        ),
                      )),
                      Expanded(
                          child: ReusableCard(
                        onPressed: () {
                          setState(() {
                            HapticFeedback.mediumImpact();
                            selectedMeal = Meal.afterMeal;
                          });
                        },
                        color: selectedMeal == Meal.afterMeal
                            ? kActiveCardColour
                            : CupertinoDynamicColor.resolve(
                                backGroundColor, context),
                        cardChild: IconFont(
                          icon: CupertinoIcons.battery_100,
                          lable: AppLocalization.of(context)
                              .translate('after_meal_state'),
                          textStyle: selectedMeal == Meal.afterMeal
                              ? kSelctedTextStyle
                              : kLabelTextStyle,
                          colorStyle: selectedMeal == Meal.afterMeal
                              ? const Color(0xFFFFFFFF)
                              : const Color(0xFFDFDDF0),
                        ),
                      ))
                    ],
                  ),
                ),
                Container(
                  child: ReusableCard(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: 350.0,
                              color: CupertinoDynamicColor.resolve(
                                  backGroundColor, context),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        CupertinoButton(
                                          child: Text(
                                              AppLocalization.of(context)
                                                  .translate('cancel')),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        CupertinoButton(
                                          child: Text(
                                              AppLocalization.of(context)
                                                  .translate('done')),
                                          onPressed: () {
                                            setState(() {
                                              glU = _selectedGluInt +
                                                  _selectedGluFloat / 10;
                                              Navigator.of(context).pop();
                                            });
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
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: CupertinoPicker(
                                              scrollController:
                                                  new FixedExtentScrollController(
                                                      initialItem:
                                                          glU.truncate()),
                                              itemExtent: 45.0,
                                              backgroundColor:
                                                  CupertinoDynamicColor.resolve(
                                                      backGroundColor, context),
                                              onSelectedItemChanged:
                                                  (int index) {
                                                _selectedGluInt = index;
                                              },
                                              children:
                                                  new List<Widget>.generate(14,
                                                      (int index) {
                                                return new Center(
                                                  child: new Text(
                                                    '$index.',
                                                    style: TextStyle(
                                                        color: kDarkColour),
                                                  ),
                                                );
                                              })),
                                        ),
                                        Expanded(
                                          child: CupertinoPicker(
                                              scrollController:
                                                  new FixedExtentScrollController(
                                                      initialItem:
                                                          _selectedGluFloat),
                                              itemExtent: 45.0,
                                              backgroundColor:
                                                  CupertinoDynamicColor.resolve(
                                                      backGroundColor, context),
                                              onSelectedItemChanged:
                                                  (int index) {
                                                _selectedGluFloat = index;
                                              },
                                              children:
                                                  new List<Widget>.generate(10,
                                                      (int index) {
                                                return new Center(
                                                  child: new Text('$index',
                                                      style: TextStyle(
                                                          color: kDarkColour)),
                                                );
                                              })),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    color:
                        CupertinoDynamicColor.resolve(backGroundColor, context),
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          AppLocalization.of(context).translate('bs'),
                          style: kLabelTextStyle,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: <Widget>[
                            Text(
                              glU.toString(),
                              style: kNumberTextStyle,
                            ),
                            const Text(
                              'mmol/L',
                              style: kNumberTextStyle,
                            )
                          ],
                        ),
                        Text(
                          AppLocalization.of(context).translate('tap_toset'),
                          style: kLabelTextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
                ButtomButton(
                  onTap: () {
                    if (_voiceInput != "") {
                      print(_voiceInput);
                      List bsList = checkBS(_voiceInput);
                      print(bsList);
                      if (bsList[0] == true) {
                        if (bsList[2] > 0 && bsList[2] <= 14) {
                          var date = new DateTime.now().toLocal();
                          String time =
                              "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
                          BloodSugarDB bloodSugarDB = BloodSugarDB(
                            glu: bsList[2],
                            state: bsList[1],
                            date: time,
                          );
                          BsDataBaseProvider.db.insert(bloodSugarDB);
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => BSResultScreen(
                                      glu: bsList[2], state: bsList[1])));
                        } else {
                          return showDialog<void>(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap button!
                              builder: (BuildContext context) {
                                return CupertinoAlertDialog(
                                  title: Text(
                                    AppLocalization.of(context).translate(
                                        'bs_screen_voice_failed_title'),
                                  ),
                                  content: Text(AppLocalization.of(context)
                                      .translate(
                                          'bs_screen_rangeWarning')),
                                  actions: <Widget>[
                                    CupertinoDialogAction(
                                      child: Text(
                                        AppLocalization.of(context)
                                            .translate('ok'),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                        }
                      } else {
                        // 匹配失败
                        return showDialog<void>(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                title: Text(
                                  AppLocalization.of(context).translate(
                                      'bs_screen_voice_failed_title'),
                                ),
                                content: Text(AppLocalization.of(context)
                                    .translate(
                                        'bs_screen_voice_failed_content')),
                                actions: <Widget>[
                                  CupertinoDialogAction(
                                    child: Text(
                                      AppLocalization.of(context)
                                          .translate('ok'),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            });
                      }
                    } else {
                      if (selectedMeal != null) {
                        var date = new DateTime.now().toLocal();
                        String time =
                            "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
                        BloodSugarDB bloodSugarDB = BloodSugarDB(
                          glu: glU,
                          state: selectedMeal.index,
                          date: time,
                        );
                        BsDataBaseProvider.db.insert(bloodSugarDB);
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => BSResultScreen(
                                    glu: glU, state: selectedMeal.index)));
                      } else {
                        return showDialog<void>(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                title: Text(
                                  AppLocalization.of(context)
                                      .translate('bs_screen_stateWarning'),
                                ),
                                actions: <Widget>[
                                  CupertinoDialogAction(
                                    child: Text(
                                      AppLocalization.of(context)
                                          .translate('ok'),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            });
                      }
                    }
                  },
                  buttonTitle: AppLocalization.of(context).translate('submit'),
                ),
                const SizedBox(
                  height: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
