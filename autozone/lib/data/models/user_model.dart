class UserModel {
  final String name;
  final String role;
  final String joinDate;
  final String imageUrl;

  UserModel({
    required this.name,
    required this.role,
    required this.joinDate,
    required this.imageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['nombre'],
      role: json['cargo'],
      joinDate: json['fecha_ingreso'],
      imageUrl: json['foto'],
    );
  }
}

