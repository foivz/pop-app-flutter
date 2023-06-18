enum LoginExceptionType {
  message,
  storeMissing,
}

class LoginException implements Exception {
  late String messageForUser;
  LoginExceptionType type = LoginExceptionType.message;
  bool isError = false;

  LoginException(String serverStatusMessage) {
    switch (serverStatusMessage) {
      case "USER NEEDS STORE":
        messageForUser = "You are not assigned to any stores, yet!";
        type = LoginExceptionType.storeMissing;
        break;
      case "This user hasn't been confirmed yet. Please contact your admin.":
        messageForUser = "Account awaiting confirmation.\nPlease be patient and try again later.";
        break;
      default:
        messageForUser = "Check your username and password!";
        isError = true;
    }
  }
}
