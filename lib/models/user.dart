import 'package:pop_app/models/store.dart';
import 'package:pop_app/utils/secure_storage.dart';

class User {
  late String firstName;
  late String lastName;
  late String username;
  late String email;
  late String password;
  late Store store;
  late double balance;
  UserRole? _role;

  static void storeUserData(username, password) {
    SecureStorage.setUsername(username);
    SecureStorage.setPassword(password);
  }

  static User loggedIn = User();

  UserRole? get role => _role;

  void setRole(UserRole role) {
    if (UserRole._roles.contains(role)) {
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

  User.full({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.password,
    required UserRole role,
  }) {
    setRole(role);
  }
}

enum UserRoleType { buyer, seller }

class UserRole {
  late final int id;

  /// Use this field only for API, for displaying use the "getPrintableName" method.
  late final UserRoleType type;

  UserRole._(this.id, this.type);

  /// Define all possible roles right here:
  static final List<UserRole> _roles = List.from([
    UserRole._(3, UserRoleType.seller),
    UserRole._(1, UserRoleType.buyer),
  ]);

  static UserRole? getRole(UserRoleType roleType) {
    return _roles.where((role) => role.type == roleType).firstOrNull;
  }

  /// Use another overload of the method with enum parameter if you can!
  static UserRole? getRoleByName(String roleName) {
    return _roles.where((role) => role.type.name == roleName).firstOrNull;
  }

  /// Add conditions for special cases or localization here.
  /// This is where a role's readable name is returned to the user.
  String getPrintableName() {
    return type.name;
  }
}

/// Only used in registration purposes
class NewUser extends User {
  bool registered = false;
}
