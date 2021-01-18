import 'package:flutter/material.dart';
import 'package:wasser/models/models_proxy.dart';
import 'package:wasser/widgets/bar_chart.widget.dart';
import 'package:wasser/services/services_proxy.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsageSummaryScreen extends StatelessWidget {
  final void Function(BuildContext context, int idx) navigator;
  final _usageService = WaterUsageDataService();
  static const _periods = const ["Last 7 days", "Latest Month", "Year to date", "Last 5 years", "All time"];
  final List<DropdownMenuItem<String>> _periodselectdropdownItems = _periods
      .map((e) => DropdownMenuItem<String>(
            value: e,
            child: Text(e),
          ))
      .toList();
  int _selectedPeriodIdx = 0;

  UsageSummaryScreen({this.navigator});

  List<RemainingBalanceModel> _mapToUsageModel(List<QueryDocumentSnapshot> documents) {
    return documents.map((e) => RemainingBalanceModel.fromJson(e.data())).toList();
  }

  List<RemainingBalanceModel> _mapTestData(List<Map<String, dynamic>> documents) {
    return documents.map((e) => RemainingBalanceModel.fromJson(e)).toList();
  }

  _testDataStream() {
    var initDate = DateTime.now();
    List<Map<String, dynamic>> _testData = [
      {"id": "rand1", "balance": 1200, "dateRecorded": Timestamp.fromDate(initDate)},
      {"id": "rand2", "balance": 1600, "dateRecorded": Timestamp.fromDate(initDate.subtract(Duration(days: 1)))},
      {"id": "rand3", "balance": 1901, "dateRecorded": Timestamp.fromDate(initDate.subtract(Duration(days: 2)))},
      {"id": "rand4", "balance": 1955, "dateRecorded": Timestamp.fromDate(initDate.subtract(Duration(days: 3)))},
      {"id": "rand3", "balance": 2901, "dateRecorded": Timestamp.fromDate(initDate.subtract(Duration(days: 4)))},
      {"id": "rand3", "balance": 2001, "dateRecorded": Timestamp.fromDate(initDate.subtract(Duration(days: 5)))},
      {"id": "rand3", "balance": 1501, "dateRecorded": Timestamp.fromDate(initDate.subtract(Duration(days: 6)))},
    ];
    return _testData; //Stream.fromIterable(_testData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Usage"),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ListTile(
            title: Text("Selected period"),
            trailing: DropdownButton(
                value: _periods[_selectedPeriodIdx],
                onChanged: (String newValue) {
                  // setState({}) TODO
                },
                items: _periodselectdropdownItems),
          ),
          SizedBox(
            height: 24,
          ),
          StreamBuilder(
            stream: null,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              // if (!snapshot.hasData) return CircularProgressIndicator();

              // return BarChartSample4(
              //   usageData: _mapToUsageModel(snapshot.data.docs),
              // );

              var dat = _mapTestData(_testDataStream());

              return BarChartSample4(usageData: dat);
            },
          ),
        ]),
      ),
    );
  }
}
