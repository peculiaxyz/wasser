import 'package:flutter/material.dart';
import 'package:wasser/models/models_proxy.dart';
import 'package:wasser/widgets/bar_chart.widget.dart';
import 'package:wasser/services/services_proxy.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:wasser/shared/shared_proxy.dart' show calculateWaterUsage;
import 'package:wasser/widgets/widgets.dart';
import 'package:wasser/shared/shared_proxy.dart' show Logging;

class UsageSummaryScreen extends StatefulWidget {
  final void Function(BuildContext context, int idx) navigator;
  UsageSummaryScreen({this.navigator});

  @override
  _UsageSummaryScreenState createState() => _UsageSummaryScreenState();
}

class _UsageSummaryScreenState extends State<UsageSummaryScreen> {
  var log = Logging.getLogger();
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
        log.w("Unsuported sample size/period [$_samplePeriod]");
        return _usageService.getRecentUsageInfo(SamplePeriodState.DEFAULT_SAMPLE_SIZE);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Usage"),
        actions: [SharedContextMenuWidget()],
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

              return WasserBarChart(
                usageData: _mapToUsageModel(snapshot.data.docs),
              );
            },
          ),
        ]),
      ),
    );
  }
}
