/* 红色的那个确定按钮小组件，返回的是一个GestureDetector */
import 'package:flutter/material.dart';
import 'package:bp_notepad/components/constants.dart';

class ButtomButton extends StatelessWidget {
  ButtomButton({@required this.onTap, @required this.buttonTitle});
  final Function onTap;
  final String buttonTitle;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Center(
          child: Text(
            buttonTitle,
            style: kButtomLableTextStyle,
          ),
        ),
        margin: EdgeInsets.all(5.0),
        padding: EdgeInsets.only(bottom: 5.0),
        width: double.infinity,
        height: kBottomContainerHeight,
        decoration: BoxDecoration(
          color: kBottomContainerColour, //颜色
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }
}
