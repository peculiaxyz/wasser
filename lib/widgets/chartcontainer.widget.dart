import 'package:flutter/material.dart';

class WasserChartContainer extends StatelessWidget {
  final Widget chartWidget;
  WasserChartContainer({this.chartWidget});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: chartWidget,
        ),
      ),
    );
  }
}
