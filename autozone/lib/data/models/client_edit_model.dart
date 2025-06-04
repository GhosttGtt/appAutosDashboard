class ClientEditModel {
  int id;
  String name;
  String lastname;
  String phone;
  String email;

  ClientEditModel({
    required this.id,
    required this.name,
    required this.lastname,
    required this.phone,
    required this.email,
  });

  factory ClientEditModel.fromJson(Map<String, dynamic> json) {
    return ClientEditModel(
      id: json['id'],
      name: json['name'],
      lastname: json['lastname'],
      phone: json['phone'],
      email: json['email'],
    );
  }
}
