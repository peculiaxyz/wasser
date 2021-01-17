import 'package:cloud_firestore/cloud_firestore.dart';

class WaterUsage {
  String usageID;
  double usage;
  DateTime dateRecorded;

  WaterUsage({this.usageID, this.usage, this.dateRecorded});

  static DateTime convertTmStampToDate(Timestamp tmstamp) {
    return tmstamp.toDate();
  }

  factory WaterUsage.fromJson(Map<String, dynamic> jsonData) {
    return WaterUsage(
        usageID: jsonData["usageID"],
        usage: jsonData["usage"],
        dateRecorded: convertTmStampToDate(jsonData["dateRecorded"] as Timestamp));
  }

  Map<String, dynamic> toJson() {
    return {"usageID": usageID, "usage": usage, "dateRecorded": dateRecorded};
  }
}
