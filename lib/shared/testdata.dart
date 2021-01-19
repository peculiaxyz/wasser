import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wasser/models/models_proxy.dart';

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
