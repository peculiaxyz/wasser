import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wasser/models/models_proxy.dart';

class BarChartSample4 extends StatefulWidget {
  final List<WaterUsage> usageData;

  @override
  State<StatefulWidget> createState() => BarChartSample4State();

  BarChartSample4({this.usageData});
}

class BarChartSample4State extends State<BarChartSample4> {
  final Color dark = const Color(0xff3b8c75);
  final Color normal = const Color(0xff64caad);
  final Color light = const Color(0xff73e8c9);

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
                  getTextStyles: (value) => const TextStyle(color: Color(0xff939393), fontSize: 10),
                  margin: 10,
                  getTitles: (double value) {
                    switch (value.toInt()) {
                      case 0:
                        return 'Sun';
                      case 1:
                        return 'Mon';
                      case 2:
                        return 'Tue';
                      case 3:
                        return 'Wed';
                      case 4:
                        return 'Thur';
                      case 5:
                        return 'Fri';
                      case 6:
                        return 'Sat';
                      default:
                        return '';
                    }
                  },
                ),
                leftTitles: SideTitles(
                  reservedSize: 60,
                  getTitles: (val) {
                    return "$val";
                  },
                  showTitles: false,
                  getTextStyles: (value) => const TextStyle(
                      color: Color(
                        0xff939393,
                      ),
                      fontSize: 10),
                  margin: 0,
                ),
              ),
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
    return widget.usageData.map((e) {
      xAxisPosition++;
      return BarChartGroupData(x: xAxisPosition, barRods: [
        BarChartRodData(
            width: 20, y: e.usage, rodStackItems: [BarChartRodStackItem(xAxisPosition as double, e.usage, dark)])
      ]);
    }).toList();
  }
}
