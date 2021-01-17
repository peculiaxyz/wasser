import 'package:flutter/material.dart';
import 'package:wasser/screens/screens.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wasser/screens/track.screen.dart';

import 'widgets/common.widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(WasserApp());
}

class WasserApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wasser',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      routes: {
        "/": (context) => _WasserAppContainer(),
        "/usage": (context) => UsageSummaryScreen(),
        "/balance": (context) => UsageSummaryScreen(),
        "/track": (context) => TrackUsageScreen(),
      },
    );
  }
}

class _WasserAppContainer extends StatefulWidget {
  @override
  __WasserAppContainerState createState() => __WasserAppContainerState();
}

class __WasserAppContainerState extends State<_WasserAppContainer> {
  int _currentIdx = 0;

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

  _onActiveViewChanged(int viewIdx) {
    setState(() {
      _currentIdx = viewIdx;
    });
  }

  Widget _getCurrenWidget() {
    switch (_currentIdx) {
      case 0:
        return UsageSummaryScreen();
      case 1:
        return UsageSummaryScreen();
      case 2:
        return TrackUsageScreen();
      default:
        return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getCurrenWidget(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIdx,
        selectedItemColor: Theme.of(context).accentColor,
        onTap: (idx) => _onActiveViewChanged(idx),
        items: <BottomNavigationBarItem>[
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
        ],
      ),
    );
  }
}
