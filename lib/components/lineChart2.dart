/* 血糖图表小组件 */
import 'package:bp_notepad/db/bs_databaseProvider.dart';
import 'package:bp_notepad/localization/appLocalization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BSLineChart extends StatefulWidget {
  @override
  _BSLineChartState createState() => _BSLineChartState();
}

class _BSLineChartState extends State<BSLineChart> {
  static const double minX = 0;
  static const double maxX = 9;
  static const double minY = 0;
  static const double maxY = 14;

  int segmentedControlGroupValue = 10;

  //绘制图表X轴Y轴的起点和终点

  List<Color> gradientColors = [
    const Color(0xff02d39a),
    const Color(0xff02d39a),
  ];

  //分值图标渐变色的配色

  double avg = 0; //平均值
  double addAll = 0; //用于计算平均值的总值

  bool showAvg = false;
  List<FlSpot> spotData = []; //绘制曲线图表的点

//获得平均值的点
  List<FlSpot> getAvgData() {
    List<FlSpot> avgSpotData = []; //一个growable的List必须使用.add进行数据装填
    for (int x = 0; x <= maxX; x++) {
      avgSpotData.add(FlSpot(x.toDouble(), avg));
    }
    return avgSpotData;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 1,
        child: FutureBuilder<List>(
          future: BsDataBaseProvider.db.getGraphData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              int showLength = 0;
              int? addLength = 0;
              if (snapshot.data!.length - segmentedControlGroupValue > 0) {
                showLength = snapshot.data!.length - segmentedControlGroupValue;
                addLength = segmentedControlGroupValue;
              } else {
                addLength = snapshot.data?.length;
              }
              if (snapshot.data!.length >= 10) {
                spotData.clear();
                addAll = 0;
                for (int x = 0; x < addLength!; x++) {
                  spotData.add(
                      FlSpot(x.toDouble(), snapshot.data?[x + showLength]));
                  addAll += snapshot.data?[x + showLength];
                }
                avg = addAll / addLength;
              } else {
                if (spotData.isEmpty)
                  for (int x = 0; x < snapshot.data!.length; x++) {
                    spotData.add((FlSpot(x.toDouble(), snapshot.data?[x])));
                    addAll += snapshot.data?[x];
                  }
                avg = addAll / snapshot.data!.length;
              }
              return Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                    color: const Color(0xFF2c4162),
                  ),
                  child: Stack(children: <Widget>[
                    Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 10,
                        ),
                        CupertinoSlidingSegmentedControl(
                            thumbColor: const Color(0xFF23344e),
                            groupValue: segmentedControlGroupValue,
                            children: <int, Widget>{
                              10: Text(
                                AppLocalization.of(context)
                                    .translate('chart_range_10'),
                                style: TextStyle(
                                    color: CupertinoColors.systemGrey),
                              ),
                              20: Text(
                                AppLocalization.of(context)
                                    .translate('chart_range_20'),
                                style: TextStyle(
                                    color: CupertinoColors.systemGrey),
                              ),
                              30: Text(
                                AppLocalization.of(context)
                                    .translate('chart_range_30'),
                                style: TextStyle(
                                    color: CupertinoColors.systemGrey),
                              )
                            },
                            onValueChanged: (i) {
                              setState(() {
                                segmentedControlGroupValue = i as int;
                              });
                            }),
                        Text(
                          AppLocalization.of(context)
                              .translate('bs_chart_tittle'),
                          style: TextStyle(
                              color: const Color(0xFFFFFFFF),
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2),
                          textAlign: TextAlign.center,
                        ),
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(18),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 18.0, left: 12.0, top: 24, bottom: 12),
                              child: LineChart(
                                showAvg ? avgData() : mainData(),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              width: 60,
                              height: 34,
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    showAvg = !showAvg;
                                  });
                                },
                                child: Text(
                                  AppLocalization.of(context)
                                      .translate('bs_chart_subtittle'),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: showAvg
                                        ? const Color(0xFFFFFFFF)
                                            .withOpacity(0.5)
                                        : const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ]));
            } else {
              return CupertinoActivityIndicator();
            }
          },
        ));
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
            sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          // getTextStyles: (value) => const TextStyle(
          //     color: const Color(0xB3FFFFFF),
          //     fontWeight: FontWeight.bold,
          //     fontSize: 12),
          getTitlesWidget: (value, titleMeta) {
            switch (value.toInt()) {
              case 0:
                return Text('1');
              case 4:
                return Text('5');
              case 9:
                return Text('10');
              case 14:
                return Text('15');
              case 19:
                return Text('20');
              case 24:
                return Text('25');
              case 29:
                return Text('30');
            }
            return Text('');
          },
          // margin: 8,
        )),
        leftTitles: AxisTitles(
            sideTitles: SideTitles(
          showTitles: true,
          // getTextStyles: (value) => const TextStyle(
          //   // color: Color(0xff67727d),
          //   color: const Color(0xB3FFFFFF),
          //   fontWeight: FontWeight.bold,
          //   fontSize: 14,
          // ),
          getTitlesWidget: (value, titleMeta) {
            switch (value.toInt()) {
              case 0:
                return Text('0');
              case 2:
                return Text('2');
              case 4:
                return Text('4');
              case 6:
                return Text('6');
              case 8:
                return Text('8');
              case 10:
                return Text('10');
              case 12:
                return Text('12');
              case 14:
                return Text('14');
            }
            return Text('');
          },
          // margin: 8,
          reservedSize: 30,
        )),
      ),
      borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(color: const Color(0xFF707b94), width: 4),
            left: BorderSide(
              color: Colors.transparent,
            ),
            right: BorderSide(
              color: Colors.transparent,
            ),
            top: BorderSide(
              color: Colors.transparent,
            ),
          )),
      minX: minX,
      maxX: (segmentedControlGroupValue - 1).toDouble(),
      minY: minY,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: spotData,
          isCurved: true,
          curveSmoothness: 0,
          gradient: LinearGradient(colors: gradientColors),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
                colors: gradientColors
                    .map((color) => color.withOpacity(0.3))
                    .toList()),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
            sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          // getTextStyles: (value) => const TextStyle(
          //     color: Color(0xff68737d),
          //     fontWeight: FontWeight.bold,
          //     fontSize: 16),
          getTitlesWidget: (value, titleMeta) {
            switch (value.toInt()) {}
            return Text('');
          },
          // margin: 8,
        )),
        leftTitles: AxisTitles(
            sideTitles: SideTitles(
          showTitles: true,
          // getTextStyles: (value) => const TextStyle(
          //   color: const Color(0xff67727d),
          //   fontWeight: FontWeight.bold,
          //   fontSize: 15,
          // ),
          getTitlesWidget: (value, titleMeta) {
            switch (value.toInt()) {
              case 0:
                return Text('0');
              case 2:
                return Text('2');
              case 4:
                return Text('4');
              case 6:
                return Text('6');
              case 8:
                return Text('8');
              case 10:
                return Text('10');
              case 12:
                return Text('12');
              case 14:
                return Text('14');
            }
            return Text('');
          },
          reservedSize: 30,
          // margin: 8,
        )),
      ),
      borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(
              color: const Color(0xFF707b94),
              width: 4,
            ),
            left: BorderSide(
              color: Colors.transparent,
            ),
            right: BorderSide(
              color: Colors.transparent,
            ),
            top: BorderSide(
              color: Colors.transparent,
            ),
          )),
      minX: minX,
      maxX: maxX,
      minY: minY,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: getAvgData(),
          isCurved: true,
          gradient: LinearGradient(colors: [
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2)!,
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2)!,
          ]),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
              ])),
        ),
      ],
    );
  }
}
