import 'package:cloud_firestore/cloud_firestore.dart';

class RemainingBalanceModel {
  String id;
  double balance;
  DateTime dateRecorded;

  RemainingBalanceModel({this.id, this.balance, this.dateRecorded});

  static DateTime convertTmStampToDate(Timestamp tmstamp) {
    return tmstamp.toDate();
  }

  factory RemainingBalanceModel.fromJson(Map<String, dynamic> jsonData) {
    return RemainingBalanceModel(
        id: jsonData["id"],
        balance: jsonData["balance"],
        dateRecorded: convertTmStampToDate(jsonData["dateRecorded"] as Timestamp));
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "balance": balance, "dateRecorded": dateRecorded};
  }
}
