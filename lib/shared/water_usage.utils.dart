import 'package:wasser/models/models_proxy.dart';

List<WaterUsage> calculateWaterUsage(List<RemainingBalanceModel> balanceData) {
  var result = balanceData.map((e) {
    DateTime previousDate = e.dateRecorded.subtract(Duration(days: 1));
    var previousDayReading = balanceData.where((element) => element.dateRecorded == previousDate).toList();
    double previousDayBalance = previousDayReading.isEmpty ? 0 : previousDayReading.first.balance;
    double approxUsage = previousDayBalance - e.balance;

    return WaterUsage(usageID: e.id, dateRecorded: e.dateRecorded, usage: (approxUsage).abs());
  }).toList();
  return result;
}
