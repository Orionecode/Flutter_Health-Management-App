/* BMI结算界面 */
import 'package:bp_notepad/components/lineChart3.dart';
import 'package:bp_notepad/localization/appLocalization.dart';
import 'package:flutter/cupertino.dart';
import 'package:bp_notepad/components/constants.dart';
import 'package:bp_notepad/components/resusableCard.dart';

TextStyle? selectedStyle;

class BMIResultScreen extends StatefulWidget {
  BMIResultScreen({required this.bmiResult, required this.brResult});

  final double bmiResult;
  final double brResult;

  @override
  _BMIResultScreenState createState() => _BMIResultScreenState();
}

class _BMIResultScreenState extends State<BMIResultScreen> {
  String? resultText;

  @override
  Widget build(BuildContext context) {
    var deviceData = MediaQuery.of(context);
    if (widget.bmiResult> 25 || widget.bmiResult< 18.5) {
      selectedStyle = kWarningResultTextStyle;
    } else {
      selectedStyle = kBMINormalResultTextStyle;
    }
    if (widget.bmiResult> 25 && widget.bmiResult<= 30) {
      resultText = AppLocalization.of(context).translate('overweight');
    } else if (widget.bmiResult> 18.5 && widget.bmiResult<= 25) {
      resultText = AppLocalization.of(context).translate('healthy_weight');
    } else if (widget.bmiResult<= 18.5) {
      resultText = AppLocalization.of(context).translate('underweight');
    } else if (widget.bmiResult> 30) {
      resultText = AppLocalization.of(context).translate('obese');
    } else {
      resultText = 'Error';
    }
    return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.systemGroupedBackground,
        navigationBar: CupertinoNavigationBar(
          backgroundColor:
              CupertinoTheme.of(context).barBackgroundColor.withOpacity(1.0),
          middle: Text(
            AppLocalization.of(context).translate('index_report'),
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
                                resultText!.toUpperCase(),
                                style: selectedStyle,
                              ),

                              Text(
                                "BMI:${widget.bmiResult.toString()}",
                                style: TextStyle(
                                    color: CupertinoDynamicColor.resolve(
                                        textColor, context),
                                    fontSize: 45,
                                    fontWeight: FontWeight.bold),
                              ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: [
                              //     Text(
                              //       'BF:',
                              //       style: kBMITextStyle,
                              //     ),
                              //     Text(widget.brResult.toString(),
                              //         style: kBMITextStyle),
                              //     Text(
                              //       "%",
                              //       style: kBMITextStyle,
                              //     ),
                              //   ],
                              // ),
                              BmiLineChart()
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
