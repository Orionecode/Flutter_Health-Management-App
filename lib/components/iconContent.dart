/* 大按钮里面的图标和文字小组件*/
import 'package:flutter/material.dart';

class IconFont extends StatelessWidget {
  IconFont({this.icon, this.lable, this.textStyle,this.colorStyle});
  final IconData icon;
  final String lable;
  final TextStyle textStyle;
  final Color colorStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          size: 80.0,
          color: colorStyle
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(lable, style: textStyle)
      ],
    );
  }
}
