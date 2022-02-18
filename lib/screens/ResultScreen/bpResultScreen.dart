/* 血压结算界面 */
import 'package:bp_notepad/components/resusableCard.dart';
import 'package:bp_notepad/localization/appLocalization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bp_notepad/components/constants.dart';
import 'package:bp_notepad/components/lineChart1.dart';

TextStyle selectedStyle;

class BPResultScreen extends StatefulWidget {
  final int sbp;
  final int dbp;
  final int pulse;
  BPResultScreen({this.sbp, this.dbp, this.pulse});

  @override
  _BPResultScreenState createState() => _BPResultScreenState();
}

class _BPResultScreenState extends State<BPResultScreen> {
  String resultText;

  Widget build(BuildContext context) {
    var deviceData = MediaQuery.of(context);
    if (widget.sbp > 180 || widget.dbp > 120) {
      resultText = AppLocalization.of(context).translate('HC');
      selectedStyle = kHyperCrisisResultTextStyle;
    } else if (widget.sbp > 140 || widget.dbp > 90) {
      resultText = AppLocalization.of(context).translate('HS2');
      selectedStyle = kHyperS2ResultTextStyle;
    } else if (widget.sbp > 128 || widget.dbp > 80) {
      resultText = AppLocalization.of(context).translate('HS1');
      selectedStyle = kHyperS1ResultTextStyle;
    } else if (widget.sbp > 120) {
      resultText = AppLocalization.of(context).translate('Elevated');
      selectedStyle = kNormalResultTextStyle;
    } else if (widget.sbp < 90 || widget.dbp < 60) {
      resultText = AppLocalization.of(context).translate('LBP');
      selectedStyle = kHyperCrisisResultTextStyle;
    } else {
      resultText = AppLocalization.of(context).translate('Normal');
      selectedStyle = kNormalResultTextStyle;
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
                    child: Column(
                      children: <Widget>[
                        Expanded(
                            child: ReusableCard(
                          color: CupertinoDynamicColor.resolve(
                              backGroundColor, context),
                          cardChild: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                resultText,
                                style: selectedStyle,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppLocalization.of(context)
                                        .translate('sys'),
                                    style: TextStyle(
                                        color: CupertinoDynamicColor.resolve(
                                            textColor, context),
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(widget.sbp.toString(),
                                      style: TextStyle(
                                          color: CupertinoDynamicColor.resolve(
                                              textColor, context),
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                    "mmHg",
                                    style: TextStyle(
                                        color: CupertinoDynamicColor.resolve(
                                            textColor, context),
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppLocalization.of(context)
                                        .translate('dia'),
                                    style: TextStyle(
                                        color: CupertinoDynamicColor.resolve(
                                            textColor, context),
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(widget.dbp.toString(),
                                      style: TextStyle(
                                          color: CupertinoDynamicColor.resolve(
                                              textColor, context),
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                    "mmHg",
                                    style: TextStyle(
                                        color: CupertinoDynamicColor.resolve(
                                            textColor, context),
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppLocalization.of(context)
                                        .translate('pulse'),
                                    style: TextStyle(
                                        color: CupertinoDynamicColor.resolve(
                                            textColor, context),
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(widget.pulse.toString(),
                                      style: TextStyle(
                                          color: CupertinoDynamicColor.resolve(
                                              textColor, context),
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                    "BMP",
                                    style: TextStyle(
                                        color: CupertinoDynamicColor.resolve(
                                            textColor, context),
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              BPLineChart(),
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
