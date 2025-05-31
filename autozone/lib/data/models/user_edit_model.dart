class UserEditModel {
  int id;
  String name;
  String email;
  String role;
  String username;

  UserEditModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.username,
  });

  factory UserEditModel.fromJson(Map<String, dynamic> json) {
    return UserEditModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      username: json['username'],
    );
  }
}
