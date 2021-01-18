import 'package:flutter/material.dart';

class BottomNavState with ChangeNotifier {
  int _currentIdx = 0;

  int get currentIdx => _currentIdx;

  void setActivePageIdx(int idx) {
    _currentIdx = idx;
    notifyListeners();
  }
}

class GenericOperationResult {
  bool successful = true;
  String message = "Process complete";

  GenericOperationResult({this.successful, this.message});

  factory GenericOperationResult.failed({String errorMessage}) {
    return GenericOperationResult(successful: false, message: errorMessage ?? "Unknown error, please try again");
  }

  factory GenericOperationResult.success({String successMessage}) {
    return GenericOperationResult(successful: false, message: successMessage ?? "Process complete");
  }
}

class DBOperationResult extends GenericOperationResult {}

class AuthResult extends GenericOperationResult {}
