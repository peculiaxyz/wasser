enum MessageStatus { Sent, Received, Read }
enum MessageQueueStatus { Queued, InProgress, Resolved, Parked }
enum UserStatus { NOT_SET, ONLINE, AWAY, OFFLINE, DISABLES }
enum UserRole { KNOWN_USER, AGENT, CUSTOMER, MANAGER, ADMIN }

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
