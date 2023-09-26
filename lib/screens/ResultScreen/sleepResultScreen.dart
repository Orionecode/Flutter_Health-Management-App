/* 血糖结算界面 */
import 'package:bp_notepad/components/lineChart4.dart';
import 'package:bp_notepad/components/resusableCard.dart';
import 'package:bp_notepad/localization/appLocalization.dart';
import 'package:flutter/cupertino.dart';
import 'package:bp_notepad/components/constants.dart';

TextStyle? selectedStyle;

class SleepResultScreen extends StatefulWidget {
  final double sleep;
  final int state;
  SleepResultScreen({required this.sleep, required this.state});

  @override
  _SleepResultScreenState createState() => _SleepResultScreenState();
}

class _SleepResultScreenState extends State<SleepResultScreen> {
  late String resultText;

  Widget build(BuildContext context) {
    var deviceData = MediaQuery.of(context);
    if (widget.state == 0) {
        selectedStyle = kWarningBSResultTextStyle;
        resultText = AppLocalization.of(context).translate("sleep_input_button1");
    } else {
        selectedStyle = kNormalBSResultTextStyle;
        resultText = AppLocalization.of(context).translate("sleep_input_button2");
    }
    return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.systemGroupedBackground,
        navigationBar: CupertinoNavigationBar(
          backgroundColor:
              CupertinoTheme.of(context).barBackgroundColor.withOpacity(1.0),
          middle: Text(
            AppLocalization.of(context).translate('statistics_added'),
          ),
        ),
        child: Container(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(5.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: double.infinity),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    height: deviceData.size.height,
                    width: double.infinity,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                            child: ReusableCard(
                          color: CupertinoDynamicColor.resolve(
                              backGroundColor, context),
                          cardChild: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                resultText,
                                style: selectedStyle,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(widget.sleep.toString(),
                                      style: TextStyle(
                                          color: CupertinoDynamicColor.resolve(
                                              textColor, context),
                                          fontSize: 45,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                    AppLocalization.of(context).translate("hour"),
                                    style: TextStyle(
                                        color: CupertinoDynamicColor.resolve(
                                            textColor, context),
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SleepLineChart(),
                            ],
                          ),
                        ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
