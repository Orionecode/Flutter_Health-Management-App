import 'package:bp_notepad/components/constants.dart';
import 'package:bp_notepad/components/resusableCard.dart';
import 'package:bp_notepad/localization/appLocalization.dart';
import 'package:bp_notepad/screens/FunctionScreen/alarmScreen.dart';
import 'package:flutter/cupertino.dart';

class MedicineListScreen extends StatefulWidget {
  final List medicineList;

  const MedicineListScreen({Key key, this.medicineList}) : super(key: key);

  @override
  _MedicineListScreenState createState() => _MedicineListScreenState();
}

class _MedicineListScreenState extends State<MedicineListScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        middle: Text(AppLocalization.of(context).translate("list_screen_selecting_medication")),
        backgroundColor:
            CupertinoTheme.of(context).barBackgroundColor.withOpacity(1.0),
      ),
      child: ListView.builder(
          padding: EdgeInsets.only(top: 5.0),
          itemCount: widget.medicineList.length,
          itemBuilder: (BuildContext context, index) {
            List _medicine = widget.medicineList[index].values.toList();
            print(_medicine);
            return ReusableCard(
                color: CupertinoDynamicColor.resolve(backGroundColor, context),
                cardChild: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${_medicine[0]}",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: CupertinoDynamicColor.resolve(
                              textColor, context)),
                    ),
                    Text(
                      "${AppLocalization.of(context).translate("usage")}:${_medicine[2]}",
                      style: TextStyle(
                          fontSize: 16,
                          color: CupertinoDynamicColor.resolve(
                              textColor, context)),
                    ),
                    Text(
                      "${AppLocalization.of(context).translate("dosage")}:${_medicine[1]}",
                      style: TextStyle(
                          fontSize: 16,
                          color: CupertinoDynamicColor.resolve(
                              textColor, context)),
                    ),
                  ],
                ),
                onPressed: () {
                  print(_medicine);
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => AlarmScreen(
                          initialMedicineTitle: _medicine[0],
                          initialMedicineDosage: _medicine[1],
                          initialMedicineUsage: _medicine[2],
                        ),
                      ));
                });
          }),
    );
  }
}
