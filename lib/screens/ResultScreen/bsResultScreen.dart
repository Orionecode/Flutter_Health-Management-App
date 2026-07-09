/* 血糖结算界面 */
import 'package:bp_notepad/components/resusableCard.dart';
import 'package:bp_notepad/localization/appLocalization.dart';
import 'package:flutter/cupertino.dart';
import 'package:bp_notepad/components/constants.dart';
import 'package:bp_notepad/components/lineChart2.dart';

TextStyle? selectedStyle;

class BSResultScreen extends StatefulWidget {
  final double glu;
  final int state;
  BSResultScreen({required this.glu, required this.state});

  @override
  _BSResultScreenState createState() => _BSResultScreenState();
}

class _BSResultScreenState extends State<BSResultScreen> {
  late String resultText;

  Widget build(BuildContext context) {
    var deviceData = MediaQuery.of(context);
    if (widget.state == 0) {
      if (widget.glu > 3.9 && widget.glu < 5.5) {
        selectedStyle = kNormalBSResultTextStyle;
        resultText =
            AppLocalization.of(context).translate('bs_without_diabetes_normal');
      } else if (widget.glu <= 3.9) {
        selectedStyle = kWarningBSResultTextStyle;
        resultText = AppLocalization.of(context)
            .translate('bs_without_diabetes_Warning_L');
      } else {
        selectedStyle = kWarningBSResultTextStyle;
        resultText = AppLocalization.of(context)
            .translate('bs_without_diabetes_Warning_H');
      }
    } else {
      if (widget.glu > 4.4 && widget.glu < 7.2) {
        selectedStyle = kNormalBSResultTextStyle;
        resultText =
            AppLocalization.of(context).translate('bs_with_diabetes_normal');
      } else if (widget.glu <= 4.4) {
        selectedStyle = kWarningBSResultTextStyle;
        resultText =
            AppLocalization.of(context).translate('bs_with_diabetes_Warning_L');
      } else {
        selectedStyle = kWarningBSResultTextStyle;
        resultText =
            AppLocalization.of(context).translate('bs_with_diabetes_Warning_H');
      }
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
                                  Text(widget.glu.toString(),
                                      style: TextStyle(
                                          color: CupertinoDynamicColor.resolve(
                                              textColor, context),
                                          fontSize: 45,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                    "mmol/L",
                                    style: TextStyle(
                                        color: CupertinoDynamicColor.resolve(
                                            textColor, context),
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              BSLineChart(),
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
