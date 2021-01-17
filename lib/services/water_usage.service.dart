import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wasser/models/models_proxy.dart';

class WaterUsageDataService {
  final CollectionReference _dbUsageRef = FirebaseFirestore.instance.collection('waterusage');

  /// Last 7 days usage info
  Stream<QuerySnapshot> getRecentUsageInfo() {
    return _dbUsageRef.snapshots();
  }

  Future<GenericOperationResult> saveRemainingWaterBalance(RemainingBalanceModel data) async {
    try {
      DocumentReference docRef = await _dbUsageRef.add(data.toJson());
      await docRef.update({"id": docRef.id});
      return Future.value(GenericOperationResult.success(successMessage: "Balance record successully created"));
    } catch (e) {
      print("Remaining balance persistence error $e");
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
