/* 这是一个控制了全局一些主要颜色的文件，更改后会有全局效果
 */
import 'package:flutter/cupertino.dart';

final modalGroundColor = CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.white, darkColor: const Color(0xFF18181A));
final backGroundColor = CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.white, darkColor: CupertinoColors.systemFill);
final textColor = CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.black, darkColor: CupertinoColors.white);
const kBottomContainerHeight = 60.0; //组件参数:确定按钮高度
const kInactiveCardColour = const Color(0xFFFFFFFF); //颜色:按钮卡片未激活的颜色，也运用于很多默认背景色
const kActiveCardColour = CupertinoColors.systemBlue; //颜色:按钮卡片激活的颜色
const kBottomContainerColour = const Color(0xFFEB1555); //颜色:确定按钮的颜色
const kWhiteColour = const Color(0xFFFFFFFF); //颜色:白色
const kDarkColour = const Color(0xFF262729);

const kButtomLableTextStyle = TextStyle(
  fontSize: 28.0,
  color: const Color(0xFFFFFFFF),
);

const kLabelTextStyle = TextStyle(
  fontSize: 18.0,
  color: const Color(0xFF8D8E98),
);

const kLargeLableTextStyle = TextStyle(
  fontSize: 20.0,
  color: const Color(0xFF8D8E98),
);

const kSelctedTextStyle = TextStyle(
  fontSize: 18.0,
  color: const Color(0xFFFFFFFF),
);

const kNumberTextStyle = TextStyle(
  color: CupertinoColors.systemIndigo,
  fontSize: 38.0,
  fontWeight: FontWeight.w900,
);

const kSmallNumberTextStyle = TextStyle(
  color: CupertinoColors.systemIndigo,
  fontSize: 35.0,
  fontWeight: FontWeight.w900,
);

const kUnitTextStyle = TextStyle(
  fontSize: 22.0,
  wordSpacing: 12.0,
);

const kLargeButtonTextStyle = TextStyle(
  fontSize: 25.0,
  fontWeight: FontWeight.bold,
);

const kTitleTextStyle = TextStyle(
    fontSize: 50.0, fontWeight: FontWeight.bold, color: CupertinoColors.label);

const kNormalResultTextStyle = TextStyle(
  color: const Color(0xFF24D876),
  fontSize: 50.0,
  fontWeight: FontWeight.bold,
);

const kNormalBSResultTextStyle = TextStyle(
  color: const Color(0xFF24D876),
  fontSize: 40.0,
  fontWeight: FontWeight.bold,
);

const kWarningBSResultTextStyle = TextStyle(
  color: const Color(0xFFF44336),
  fontSize: 48.0,
  fontWeight: FontWeight.bold,
);

const kBMINormalResultTextStyle = TextStyle(
  color: const Color(0xFF24D876),
  fontSize: 40.0,
  fontWeight: FontWeight.bold,
);

const kWarningResultTextStyle = TextStyle(
  color: const Color(0xFFF44336),
  fontSize: 48.0,
  fontWeight: FontWeight.bold,
);

const kHyperS1ResultTextStyle = TextStyle(
  color: const Color(0xFFFF9800),
  fontSize: 48.0,
  fontWeight: FontWeight.bold,
);

const kHyperS2ResultTextStyle = TextStyle(
  color: const Color(0xFFEF5350),
  fontSize: 48.0,
  fontWeight: FontWeight.bold,
);

const kHyperCrisisResultTextStyle = TextStyle(
  color: const Color(0xFFB71C1C),
  fontSize: 48.0,
  fontWeight: FontWeight.bold,
);

const kBMITextStyle = TextStyle(
  fontSize: 50,
  fontWeight: FontWeight.bold,
);

const kBodyTextStyle = TextStyle(
  fontSize: 22.0,
);
const kRecordTextStyle = TextStyle(
  fontSize: 20.0,
);

const kWeightTextStyle = TextStyle(fontSize: 22, fontWeight: FontWeight.bold);

const kSnackBarTextStyle = TextStyle(
  color: const Color(0xFFFFFFFF),
  fontSize: 16.0,
);
