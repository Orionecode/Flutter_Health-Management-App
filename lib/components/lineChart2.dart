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
  static const double minx = 0;
  static const double maxx = 9;
  static const double miny = 0;
  static const double maxy = 14;

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
          future: BsDataBaseProvider.db.getGraphData(),
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
                spotDatas.clear();
                addAll = 0;
                for (int x = 0; x < addLength; x++) {
                  spotDatas
                      .add(FlSpot(x.toDouble(), snapshot.data[x + showLength]));
                  addAll += snapshot.data[x + showLength];
                }
                avg = addAll / addLength;
              } else {
                if (spotDatas.isEmpty)
                  for (int x = 0; x < snapshot.data.length; x++) {
                    spotDatas.add((FlSpot(x.toDouble(), snapshot.data[x])));
                    addAll += snapshot.data[x];
                  }
                avg = addAll / snapshot.data.length;
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
                                segmentedControlGroupValue = i;
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
            // color: Color(0xff67727d),
            color: const Color(0xB3FFFFFF),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0';
              case 2:
                return '2';
              case 4:
                return '4';
              case 6:
                return '6';
              case 8:
                return '8';
              case 10:
                return '10';
              case 12:
                return '12';
              case 14:
                return '14';
            }
            return '';
          },
          margin: 8,
          reservedSize: 30,
        ),
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
      minX: minx,
      maxX: (segmentedControlGroupValue - 1).toDouble(),
      minY: miny,
      maxY: maxy,
      lineBarsData: [
        LineChartBarData(
          spots: spotDatas,
          isCurved: true,
          curveSmoothness: 0,
          colors: gradientColors,
          barWidth: 3,
          isStrokeCapRound: true,
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
              case 2:
                return '2';
              case 4:
                return '4';
              case 6:
                return '6';
              case 8:
                return '8';
              case 10:
                return '10';
              case 12:
                return '12';
              case 14:
                return '14';
            }
            return '';
          },
          reservedSize: 30,
          margin: 8,
        ),
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
      minX: minx,
      maxX: maxx,
      minY: miny,
      maxY: maxy,
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
