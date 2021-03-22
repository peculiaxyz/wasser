import 'package:flutter/material.dart';
import 'package:wasser/screens/screens.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'models/models_proxy.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:wasser/shared/shared_proxy.dart' show Logging;

final log = Logging.getLogger();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (kIsWeb) {
    FirebaseFirestore.instance.enablePersistence();
    log.d("Web detected, enabling firstore offline persistance");
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BottomNavState()),
        ChangeNotifierProvider(create: (_) => SamplePeriodState()),
      ],
      child: const WasserApp(),
    ),
  );
}

class WasserApp extends StatelessWidget {
  const WasserApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wasser',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: _WasserAppContainer(),
    );
  }
}

class _WasserAppContainer extends StatefulWidget {
  @override
  __WasserAppContainerState createState() => __WasserAppContainerState();
}

class __WasserAppContainerState extends State<_WasserAppContainer> {
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
    context.read<BottomNavState>().setActivePageIdx(viewIdx);
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _getCurrenWidget(int idx) {
    switch (idx) {
      case 0:
        return UsageSummaryScreen();
      case 1:
        return BalanceSummaryScreen();
      case 2:
        return TrackUsageScreen();
      default:
        return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    var activeIdx = context.watch<BottomNavState>().currentIdx;

    return Scaffold(
      body: _getCurrenWidget(activeIdx),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: activeIdx,
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
