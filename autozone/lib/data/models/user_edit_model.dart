class UserEditModel {
  final int id;
  final String name;
  final String email;
  final String role;

  UserEditModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory UserEditModel.fromJson(Map<String, dynamic> json) {
    return UserEditModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
    );
  }
}
