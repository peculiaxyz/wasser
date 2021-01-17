import 'package:flutter/material.dart';

class WasserWidgets {
  static const BottomNavBarItems = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: const Icon(Icons.bar_chart),
      label: "Usage",
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.pie_chart),
      label: "Balance",
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.add_comment),
      label: "Track",
    )
  ];
}
