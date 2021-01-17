import 'package:flutter/material.dart';
import 'package:wasser/screens/screens.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(WasserApp());
}

class WasserApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wasser',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: UsageSummaryScreen(),
    );
  }
}
