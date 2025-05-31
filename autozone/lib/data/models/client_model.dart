class ClientModel {
  final int id;
  final String name;
  final String lastname;
  final String phone;
  final String email;

  ClientModel(
      {required this.id,
      required this.name,
      required this.lastname,
      required this.phone,
      required this.email});

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'],
      name: json['name'],
      lastname: json['lastname'],
      phone: json['phone'],
      email: json['email'],
    );
  }
}
