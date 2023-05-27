class User {
  late String firstName;
  late String lastName;
  late String username;
  late String email;
  late String password;
  late String role;
  late String storeName;
  bool registered = false;

  User.empty();

  User(this.firstName, this.lastName, this.username, this.email, this.password);

class UserRole {
  late int roleId;
  late String roleName;

  UserRole(this.roleId, this.roleName);
}
