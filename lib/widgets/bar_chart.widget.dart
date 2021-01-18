import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wasser/models/models_proxy.dart';

class BarChartSample4 extends StatefulWidget {
  final List<RemainingBalanceModel> usageData;

  @override
  State<StatefulWidget> createState() => BarChartSample4State();

  BarChartSample4({this.usageData});
}

class BarChartSample4State extends State<BarChartSample4> {
  final Color dark = const Color(0xff3b8c75);
  final Color normal = const Color(0xff64caad);
  final Color light = const Color(0xff73e8c9);
  final Map<int, DateTime> xSeries = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    widget.usageData.sort((a, b) => a.dateRecorded.compareTo(b.dateRecorded));
    int position = 0;
    for (var item in widget.usageData) {
      xSeries[position] = item.dateRecorded;
      position++;
    }
  }

  String formatChatDate(DateTime dt) {
    return DateFormat("EEE").format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.66,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.center,
              barTouchData: BarTouchData(
                enabled: true,
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: SideTitles(
                  showTitles: true,
                  getTextStyles: (value) => const TextStyle(color: Color(0xff939393), fontSize: 8),
                  margin: 20,
                  getTitles: (double value) {
                    DateTime dt = xSeries[value.toInt()];
                    return formatChatDate(dt);
                  },
                ),
                leftTitles: SideTitles(
                  getTitles: (val) {
                    if (val.toInt() % 150 != 0) return '';
                    var value = val / 1000;
                    return "$value";
                  },
                  showTitles: true,
                  getTextStyles: (value) => const TextStyle(
                      color: Color(
                        0xff939393,
                      ),
                      fontSize: 10),
                  margin: 0,
                ),
              ),
              axisTitleData: FlAxisTitleData(
                  show: true,
                  leftTitle: AxisTitle(titleText: "Usage in Kilolitres", showTitle: true),
                  bottomTitle: AxisTitle(
                    titleText: "Date recorded",
                  ),
                  topTitle: AxisTitle(titleText: "Last 7 days", showTitle: true)),
              gridData: FlGridData(
                show: false,
                checkToShowHorizontalLine: (value) => value % 10 == 0,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: const Color(0xffe7e8ec),
                  strokeWidth: 0,
                ),
              ),
              borderData: FlBorderData(
                show: false,
              ),
              groupsSpace: 10,
              barGroups: getData(),
            ),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> getData() {
    int xAxisPosition = -1;
    var data = widget.usageData;
    // data.sort((a, b) => a.dateRecorded.compareTo(b.dateRecorded));
    return data.map((e) {
      xAxisPosition++;
      return BarChartGroupData(x: xAxisPosition, barRods: [
        BarChartRodData(
            width: 20, y: e.balance, rodStackItems: [BarChartRodStackItem(xAxisPosition as double, e.balance, dark)])
      ]);
    }).toList();
  }
}
