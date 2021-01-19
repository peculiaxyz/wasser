import 'package:flutter/material.dart';
import 'package:wasser/models/models_proxy.dart';
import 'package:wasser/services/services_proxy.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:wasser/widgets/widgets.dart' show WasserLineChart;

class BalanceSummaryScreen extends StatefulWidget {
  final void Function(BuildContext context, int idx) navigator;
  BalanceSummaryScreen({this.navigator});

  @override
  _BalanceSummaryScreenState createState() => _BalanceSummaryScreenState();
}

class _BalanceSummaryScreenState extends State<BalanceSummaryScreen> {
  String _samplePeriod = SamplePeriodState.periods[0];
  final _usageService = WaterUsageDataService();
  final _selectedPeriodTextStyle = TextStyle(fontSize: 12, color: Colors.black54);
  final List<DropdownMenuItem<String>> _periodselectdropdownItems = SamplePeriodState.periods
      .map((e) => DropdownMenuItem<String>(
            value: e,
            child: Text(e),
          ))
      .toList();

  List<RemainingBalanceModel> _mapToBalanceModel(List<QueryDocumentSnapshot> documents) {
    return documents.map((e) => RemainingBalanceModel.fromJson(e.data())).toList();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Remaining balance"),
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
              if (!snapshot.hasData) return LinearProgressIndicator();

              return WasserLineChart(
                balanceData: _mapToBalanceModel(snapshot.data.docs),
              );
            },
          ),
        ]),
      ),
    );
  }
}
