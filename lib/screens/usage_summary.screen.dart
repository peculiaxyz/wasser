import 'package:flutter/material.dart';
import 'package:wasser/widgets/widgets.dart';

class UsageSummaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Usage"),
      ),
      body: Center(
        child: Text("TBC"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: WasserWidgets.BottomNavBarItems,
      ),
    );
  }
}
