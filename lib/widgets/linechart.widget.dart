import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wasser/models/models_proxy.dart' show RemainingBalanceModel, SamplePeriodState;
import 'package:provider/provider.dart';
import 'package:wasser/widgets/widgets.dart';
import 'package:intl/intl.dart';

class WasserLineChart extends StatefulWidget {
  final List<RemainingBalanceModel> balanceData;

  WasserLineChart({this.balanceData});

  @override
  _WasserLineChartState createState() => _WasserLineChartState();
}

class _WasserLineChartState extends State<WasserLineChart> {
  final Map<int, DateTime> xSeries = {};
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  @override
  void initState() {
    widget.balanceData.sort((a, b) => a.dateRecorded.compareTo(b.dateRecorded));
    _populateXSeriesData();
    super.initState();
  }

  _populateXSeriesData() {
    int position = 0;
    for (var item in widget.balanceData) {
      xSeries[position] = item.dateRecorded;
      position++;
    }
  }

  @override
  Widget build(BuildContext context) {
    var chatTitle = context.watch<SamplePeriodState>().currentSamplePeriod; // TODO: this does not belong here

    return WasserChartContainer(
      chartWidget: LineChart(LineChartData(
        axisTitleData: FlAxisTitleData(
            show: true,
            leftTitle: AxisTitle(titleText: "Remaining balance in Kilolitres", showTitle: true),
            bottomTitle: AxisTitle(
              titleText: "Date recorded",
            ),
            topTitle: AxisTitle(titleText: chatTitle, showTitle: true)),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: const Color(0xff37434d),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: const Color(0xff37434d),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            getTextStyles: (value) =>
                const TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 16),
            getTitles: getxAxisLabel,
            margin: 8,
          ),
          leftTitles: SideTitles(
            showTitles: true,
            getTextStyles: (value) => const TextStyle(
              color: Color(0xff67727d),
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            getTitles: getyAxisLabel,
            margin: 8,
          ),
        ),
        borderData: FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)),
        lineBarsData: [
          LineChartBarData(
            spots: _prepareChartData(),
            isCurved: true,
            colors: gradientColors,
            barWidth: 5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
            ),
            belowBarData: BarAreaData(
              show: true,
              colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
            ),
          ),
        ],
      )),
    );
  }

  String getxAxisLabel(double value) {
    DateTime dt = xSeries[value.toInt()];
    return DateFormat("EEE").format(dt);
  }

  String getyAxisLabel(double val) {
    if (val.toInt() % 150 != 0) return '';
    var value = val / 1000;
    return "$value";
  }

  List<FlSpot> _prepareChartData() {
    var data = widget.balanceData;
    int position = -1;
    return data.map((e) {
      position++;
      return FlSpot(position.toDouble(), e.balance);
    }).toList();
  }
}
