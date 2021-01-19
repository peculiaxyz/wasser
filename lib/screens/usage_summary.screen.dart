import 'package:flutter/material.dart';
import 'package:wasser/models/models_proxy.dart';
import 'package:wasser/widgets/bar_chart.widget.dart';
import 'package:wasser/services/services_proxy.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:wasser/shared/shared_proxy.dart' show calculateWaterUsage;

class UsageSummaryScreen extends StatefulWidget {
  final void Function(BuildContext context, int idx) navigator;
  UsageSummaryScreen({this.navigator});

  @override
  _UsageSummaryScreenState createState() => _UsageSummaryScreenState();
}

class _UsageSummaryScreenState extends State<UsageSummaryScreen> {
  String _samplePeriod = SamplePeriodState.periods[0];
  final _usageService = WaterUsageDataService();
  final _selectedPeriodTextStyle = TextStyle(fontSize: 12, color: Colors.black54);
  final List<DropdownMenuItem<String>> _periodselectdropdownItems = SamplePeriodState.periods
      .map((e) => DropdownMenuItem<String>(
            value: e,
            child: Text(e),
          ))
      .toList();

  List<WaterUsage> _mapToUsageModel(List<QueryDocumentSnapshot> documents) {
    var balanceData = documents.map((e) => RemainingBalanceModel.fromJson(e.data())).toList();
    return calculateWaterUsage(balanceData);
  }

  _onSamplePeriodChanged(String newPeriod) {
    _samplePeriod = newPeriod;
    context.read<SamplePeriodState>().setSamplePeriod(newPeriod);
  }

  _fetchUsageData() {
    switch (_samplePeriod) {
      case SamplePeriodState.PERIOD_LAST_7_DAYS:
        return _usageService.getRecentUsageInfo(7);
      default:
        print("Unsuported sample size");
        break;
    }
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
            title: Text(
              "Selected period",
              style: _selectedPeriodTextStyle,
            ),
            trailing: DropdownButton(
                style: _selectedPeriodTextStyle,
                value: context.watch<SamplePeriodState>().currentSamplePeriod,
                onChanged: (s) => _onSamplePeriodChanged(s),
                items: _periodselectdropdownItems),
          ),
          SizedBox(
            height: 16,
          ),
          StreamBuilder(
            stream: _fetchUsageData(),
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
