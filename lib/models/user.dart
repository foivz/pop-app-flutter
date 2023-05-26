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

  User.full(this.firstName, this.lastName, this.username, this.email,
      this.password, this.role, this.storeName);
}
