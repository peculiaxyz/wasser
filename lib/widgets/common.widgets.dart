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

class BottomNavManager extends StatelessWidget {
  static final BottomNavManager _instance = null;

  static BottomNavManager get instance => _instance;

  void navigate(BuildContext context, int pageIdx) {
    switch (pageIdx) {
      case 0:
        Navigator.pushNamed(context, "/");
        break;
      case 1:
        Navigator.pushNamed(context, "/balance");
        break;
      case 2:
        Navigator.pushNamed(context, "/track");
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (idx) => navigate(context, idx),
      items: WasserWidgets.BottomNavBarItems,
    );
  }
}
