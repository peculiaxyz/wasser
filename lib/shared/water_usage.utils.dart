import 'package:wasser/models/models_proxy.dart';
import './logging.dart' show Logging;

var log = Logging.getLogger();

List<WaterUsage> calculateWaterUsage(List<RemainingBalanceModel> balanceData) {
  log.d("Before usage calculation");
  for (var item in balanceData) {
    print(item.toJson());
  }
  var result = balanceData.map((e) {
    DateTime previousDate = e.dateRecorded.subtract(Duration(days: 1));
    var previousDayReading = balanceData.where((element) => element.dateRecorded == previousDate).toList();
    double previousDayBalance = previousDayReading.isEmpty ? e.balance : previousDayReading.first.balance;
    double approxUsage = previousDayBalance - e.balance;

    return WaterUsage(usageID: e.id, dateRecorded: e.dateRecorded, usage: (approxUsage).abs());
  }).toList();

  log.d("Before after usage calculation");
  for (var item in result) {
    print(item.toJson());
  }
  return result;
}
