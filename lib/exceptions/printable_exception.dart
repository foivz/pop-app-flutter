extension PrintableException on Exception {
  String get message {
    if (toString().startsWith("Exception: ")) {
      return toString().substring(11);
    } else {
      return toString();
    }
  }
}
