import 'dart:convert';

import 'package:pop_app/models/store.dart';
import 'package:pop_app/secure_storage.dart';

class User {
  late String firstName;
  late String lastName;
  late String username;
  late String email;
  late String password;
  late Store store;
  late double balance;
  UserRole? _role;

  static final List<UserRole> roles = List.from([UserRole(3, "seller"), UserRole(1, "buyer")]);
  static void storeUserData(userData, username, password) {
    SecureStorage.setUserData(json.encode(userData));
    SecureStorage.setUsername(username);
    SecureStorage.setPassword(password);
  }

  static User loggedIn = User();

  UserRole? get role => _role;

  void setRole(UserRole role) {
    if (roles.contains(role)) {
      _role = role;
    }
  }

  User({
    this.firstName = "",
    this.lastName = "",
    this.username = "",
    this.email = "",
    this.password = "",
    this.balance = 0.0,
  });

  User.full(this.firstName, this.lastName, this.username, this.email, this.password, UserRole role,
      this.store) {
    setRole(role);
  }
}

class UserRole {
  late int roleId;
  late String roleName;

  UserRole(this.roleId, this.roleName);
}

/// Only used in registration purposes
class NewUser extends User {
  bool registered = false;
}
