import 'package:flutter/material.dart';
import 'package:wasser/models/models_proxy.dart';
import 'package:wasser/widgets/bar_chart.widget.dart';
import 'package:wasser/services/services_proxy.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsageSummaryScreen extends StatelessWidget {
  final void Function(BuildContext context, int idx) navigator;
  final _usageService = WaterUsageDataService();

  UsageSummaryScreen({this.navigator});

  List<RemainingBalanceModel> _mapToUsageModel(List<QueryDocumentSnapshot> documents) {
    print("Attempting to map docs: $documents");
    return documents.map((e) => RemainingBalanceModel.fromJson(e.data())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Usage"),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("Last 7 days"),
          SizedBox(
            height: 52,
          ),
          StreamBuilder(
            stream: _usageService.getRecentUsageInfo(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();

              return BarChartSample4(
                usageData: _mapToUsageModel(snapshot.data.docs),
              );
            },
          ),
        ]),
      ),
    );
  }
}
