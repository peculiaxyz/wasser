import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wasser/models/models_proxy.dart';
import 'package:wasser/widgets/widgets.dart';

class WasserBarChart extends StatefulWidget {
  final List<WaterUsage> usageData;

  @override
  State<StatefulWidget> createState() => WasserBarChartState();

  WasserBarChart({this.usageData});
}

class WasserBarChartState extends State<WasserBarChart> {
  final Color dark = const Color(0xff3b8c75);
  final Color normal = const Color(0xff64caad);
  final Color light = const Color(0xff73e8c9);
  final Map<int, DateTime> xSeries = {};
  final List<WaterUsage> usageList = [];

  @override
  void initState() {
    super.initState();

    // Must plot the latest date last.
    // TODO: Move to parent widget for better flexibility
    usageList.sort((a, b) => a.dateRecorded.compareTo(b.dateRecorded));
    _populateXSeriesData();
  }

  _populateXSeriesData() {
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
    var chatTitle = context.watch<SamplePeriodState>().currentSamplePeriod;

    return WasserChartContainer(
      chartWidget: BarChart(
        BarChartData(
          alignment: BarChartAlignment.center,
          barTouchData: BarTouchData(
            enabled: true,
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(
              showTitles: true,
              getTextStyles: (value) => const TextStyle(color: Color(0xff939393), fontSize: 12),
              margin: 64,
              getTitles: getxAxisLabel,
            ),
            leftTitles: SideTitles(
              getTitles: getyAxisLabel,
              showTitles: true,
              getTextStyles: (value) => const TextStyle(
                  color: Color(
                    0xff939393,
                  ),
                  fontWeight: FontWeight.bold,
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
              topTitle: AxisTitle(titleText: chatTitle, showTitle: true)),
          gridData: FlGridData(
            show: true,
            checkToShowHorizontalLine: (value) => value % 500 == 0,
            getDrawingHorizontalLine: (value) => FlLine(
              color: const Color(0xffe7e8ec),
              strokeWidth: 0,
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          barGroups: getData(),
        ),
      ),
    );
  }

  String getxAxisLabel(double value) {
    var m = {'Mon': 'M', 'Tue': 'T', 'Wed': 'W', 'Thu': 'T', 'Fri': 'F', 'Sat': 'S', 'Sun': 'S'};
    DateTime dt = xSeries[value.toInt()];
    var dayAbbr = DateFormat("E").format(dt);
    var day = DateFormat("dd").format(dt);
    return "${m[dayAbbr]} $day";
    // return DateFormat("E dd").format(dt);
  }

  String getyAxisLabel(double val) {
    if (val.toInt() % 500 != 0) return '';
    var value = val / 1000;
    return "$value";
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
