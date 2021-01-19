import 'package:flutter/cupertino.dart';

class SamplePeriodState with ChangeNotifier {
  static const int DEFAULT_SAMPLE_SIZE = 7;
  static const PERIOD_LAST_7_DAYS = "Last 7 days";
  static const periods = const ["Last 7 days", "Latest Month", "Year to date", "Last 5 years", "All time"];

  int _currentIdx = 0;
  String _currentSamplePeriod = periods[0];

  int get currentIdx => _currentIdx;
  String get currentSamplePeriod => _currentSamplePeriod;

  void setSamplePeriodIdx(int idx) {
    _currentSamplePeriod = periods[idx];
    _currentIdx = idx;
    notifyListeners();
  }

  void setSamplePeriod(String period) {
    if (!periods.contains(period)) {
      _currentSamplePeriod = periods[0];
      _currentIdx = 0;
      notifyListeners();
      return;
    }
    _currentSamplePeriod = period;
    _currentIdx = periods.indexOf(period);
    notifyListeners();
  }
}
