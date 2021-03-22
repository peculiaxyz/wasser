import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wasser/models/models_proxy.dart';
import 'package:uuid/uuid.dart';
import 'package:wasser/shared/shared_proxy.dart' show Logging;

class WaterUsageDataService {
  final log = Logging.getLogger();
  final CollectionReference _dbUsageRef = FirebaseFirestore.instance.collection('waterusage');

  WaterUsageDataService() {}

  /// Last 7 days usage info
  Stream<QuerySnapshot> getRecentUsageInfo(int limit) {
    return _dbUsageRef.limit(limit).snapshots();
  }

  Future<RemainingBalanceModel> getByDateRecorded(RemainingBalanceModel data) async {
    QuerySnapshot res =
        await _dbUsageRef.where("dateRecorded", isEqualTo: data.toJson()["dateRecorded"]).limit(1).get();
    if (res.size <= 0) return null;
    var existingRec = res.docs[0].data();
    return RemainingBalanceModel.fromJson(existingRec);
  }

  Future<GenericOperationResult> saveRemainingWaterBalance(RemainingBalanceModel data) async {
    try {
      var existingRecord = await getByDateRecorded(data);
      if (existingRecord != null) {
        log.d("Balance record exists for date ${data.dateRecorded.toString()} With Id ${existingRecord.id}");
        data.id = existingRecord.id;
        await _dbUsageRef.doc(existingRecord.id).update(data.toJson());
        log.d("Found existing record ${existingRecord.id} for specified date, updating the balance");
        return Future.value(GenericOperationResult.success());
      }
      String newRecordId = Uuid().v4().toString();
      data.id = newRecordId;
      await _dbUsageRef.doc(newRecordId).set(data.toJson());

      log.i("New Balance record# $newRecordId successully created");
      return Future.value(GenericOperationResult.success(successMessage: "Balance record successully created"));
    } catch (e) {
      log.wtf("Remaining balance persistence error $e");
      return Future.value(GenericOperationResult.failed());
    }
  }

  // /// Create a new user profile cloud firestore record or update existing
  // Future<GenericOperationResult> createAgentProfile(AgentProfile user) async {
  //   try {
  //     print("Creating new agent profile..");
  //     await _dbUserProfileRef.doc(user.agentUID).set(user.toJson());
  //     return Future.value(GenericOperationResult.success(successMessage: "New agent profile created"));
  //   } catch (e) {
  //     print("Agent profile create error $e");
  //     return Future.value(GenericOperationResult.failed(errorMessage: "New profile create error: $e"));
  //   }
  // }

  // Future<GenericOperationResult> updateAgentProfile(AgentProfile updatedUser) async {
  //   try {
  //     DocumentSnapshot profileData = await _dbUserProfileRef.doc(updatedUser.agentUID).get();
  //     if (!profileData.exists) {
  //       // this will probably never happen?
  //       return Future.value(GenericOperationResult.failed(errorMessage: "Update failed. Agent profile does not exit"));
  //     }

  //     var existingProfile = AgentProfile.fromJson(profileData.data());
  //     existingProfile.agentName = updatedUser.agentName ?? existingProfile.agentName;
  //     existingProfile.rating = updatedUser.rating;
  //     existingProfile.status = updatedUser.status;
  //     await _dbUserProfileRef.doc(updatedUser.agentUID).update(existingProfile.toJson());

  //     return Future.value(GenericOperationResult.success(successMessage: "Agent profile updated"));
  //   } catch (e) {
  //     print("New profile create error: $e");
  //     return Future.value(GenericOperationResult.failed(errorMessage: e));
  //   }
  // }
}
