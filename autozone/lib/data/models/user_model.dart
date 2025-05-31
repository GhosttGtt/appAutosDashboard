class UserModel {
  final int id;
  final String name;
  final String username;
  final String email;
  final String photo;
  final String role;

  UserModel(
      {required this.id,
      required this.name,
      required this.username,
      required this.email,
      required this.photo,
      required this.role});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      photo: json['photo'],
      role: json['role'],
    );
  }
}
