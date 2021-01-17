import 'package:flutter/material.dart';
import 'package:wasser/widgets/widgets.dart';

class TrackUsageScreen extends StatelessWidget {
  final void Function(BuildContext context, int idx) navigator;

  TrackUsageScreen({this.navigator});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Track usage"),
      ),
      body: Scaffold(
        appBar: AppBar(title: Text("A nested scaffold")),
      ),
    );
  }
}
