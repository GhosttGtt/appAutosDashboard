class UserModel {
  final String name;
  final String username;
  final String email;
  final String password;
  final String photo;
  final String role;

  UserModel({
    required this.name,
    required this.username,
    required this.email,
    required this.password,
    required this.photo,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      photo: json['photo'],
      role: json['role'],
    );
  }
}
