/* 睡眠图表小组件 */
import 'package:bp_notepad/db/sleep_databaseProvider.dart';
import 'package:bp_notepad/localization/appLocalization.dart';
import 'package:flutter/cupertino.dart';

/// Flutter code sample for SliverAppBar

// This sample shows a [SliverAppBar] and it's behaviors when using the [pinned], [snap] and [floating] parameters.

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SleepLineChart extends StatefulWidget {
  @override
  _SleepLineChartState createState() => _SleepLineChartState();
}

class _SleepLineChartState extends State<SleepLineChart> {
  static const double minx = 0;
  static const double maxx = 9;
  //绘制图表X轴Y轴的起点和终点

  int segmentedControlGroupValue = 10;

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  // Colors.lightBlueAccent, Colors.greenAccent
  //分值图标渐变色的配色
  //一定要搞清楚带不带static有什么区别

  double avg = 0; //平均值
  double addAll = 0; //用于计算平均值的总值
  double max = 15; //用于找出最大的值
  double min = 0; //用于找出最小的值

  bool showAvg = false;
  List<FlSpot> spotDatas = []; //绘制曲线图表的点

//获得平均值的点
  List<FlSpot> getAvgData() {
    List<FlSpot> avgSpotDatas = []; //一个growable的List必须使用.add进行数据装填
    for (int x = 0; x <= maxx; x++) {
      avgSpotDatas.add(FlSpot(x.toDouble(), avg));
    }
    return avgSpotDatas;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 1,
        child: FutureBuilder<List>(
          future: SleepDataBaseProvider.db.getGraphData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              int showLength = 0;
              int addLength = 0;
              if (snapshot.data.length - segmentedControlGroupValue > 0) {
                showLength = snapshot.data.length - segmentedControlGroupValue;
                addLength = segmentedControlGroupValue;
              } else {
                addLength = snapshot.data.length;
              }
              if (snapshot.data.length >= 10) {
                //可以完整显示最近的十条记录
                spotDatas.clear();
                addAll = 0;
                for (int x = 0; x < addLength; x++) {
                  //获取最大值和最小值
                  if (snapshot.data[x + showLength] > max) {
                    max = snapshot.data[x + showLength];
                  } else if (snapshot.data[x + showLength] < min) {
                    min = snapshot.data[x + showLength];
                  }
                  //添加数值到spotData
                  spotDatas
                      .add(FlSpot(x.toDouble(), snapshot.data[x + showLength]));
                  addAll += snapshot.data[x + showLength];
                }
                avg = addAll / addLength;
              } else {
                //不能完整显示最近的十条记录
                if (spotDatas.isEmpty)
                  for (int x = 0; x < snapshot.data.length; x++) {
                    //获取最大值和最小值
                    if (snapshot.data[x] > max) {
                      max = snapshot.data[x];
                    } else if (snapshot.data[x] < min) {
                      min = snapshot.data[x];
                    }
                    //添加数值到spotData
                    spotDatas.add((FlSpot(x.toDouble(), snapshot.data[x])));
                    addAll += snapshot.data[x];
                  }
                avg = addAll / snapshot.data.length;
              }
              return Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                    color: const Color(0xFF092843),
                  ),
                  child: Stack(children: <Widget>[
                    Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 15,
                        ),
                        CupertinoSlidingSegmentedControl(
                            thumbColor: const Color(0xff072036),
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
                                segmentedControlGroupValue = i;
                              });
                            }),
                        Text(
                          AppLocalization.of(context)
                                      .translate('sleep_chart_title'),
                          style: TextStyle(
                              color: const Color(0xFFFFFFFF),
                              fontSize: 32,
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
                                color: const Color(0xFF092843)),
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
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
              color: const Color(0xB3FFFFFF),
              fontWeight: FontWeight.bold,
              fontSize: 12),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '1';
              case 4:
                return '5';
              case 9:
                return '10';
              case 14:
                return '15';
              case 19:
                return '20';
              case 24:
                return '25';
              case 29:
                return '30';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: const Color(0xB3FFFFFF),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0';
              case 10:
                return '10';
              case 20:
                return '20';
              case 30:
                return '30';
              case 40:
                return '40';
              case 50:
                return '50';
              case 60:
                return '60';
              case 70:
                return '70';
              case 80:
                return '80';
              case 90:
                return '90';
              case 100:
                return '100';
              case 110:
                return '110';
              case 120:
                return '120';
              case 130:
                return '130';
              case 140:
                return '140';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(
              color: const Color(0xFF5a687d),
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
      minX: minx,
      maxX: (segmentedControlGroupValue - 1).toDouble(),
      maxY: (((max.toInt()) ~/ 10) * 10 + 10).toDouble(),
      minY: (((min.toInt()) ~/ 10) * 10 - 10).toDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: spotDatas,
          isCurved: true,
          colors: gradientColors,
          barWidth: 3,
          isStrokeCapRound: true,
          curveSmoothness: 0,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
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
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: const Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0';
              case 10:
                return '10';
              case 20:
                return '20';
              case 30:
                return '30';
              case 40:
                return '40';
              case 50:
                return '50';
              case 60:
                return '60';
              case 70:
                return '70';
              case 80:
                return '80';
              case 90:
                return '90';
              case 100:
                return '100';
              case 110:
                return '110';
              case 120:
                return '120';
              case 130:
                return '130';
              case 140:
                return '140';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(
              color: const Color(0xFF5a687d),
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
      minX: minx,
      maxX: maxx,
      maxY: (((max.toInt()) ~/ 10) * 10 + 10).toDouble(),
      minY: (((min.toInt()) ~/ 10) * 10 - 10).toDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: getAvgData(),
          isCurved: true,
          colors: [
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2),
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2),
          ],
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(show: true, colors: [
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2)
                .withOpacity(0.1),
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2)
                .withOpacity(0.1),
          ]),
        ),
      ],
    );
  }
}
