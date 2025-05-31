class MessagesModel {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String subject;
  final String message;
  final int status;

  MessagesModel(
      {required this.id,
      required this.name,
      required this.phone,
      required this.email,
      required this.subject,
      required this.message,
      required this.status});

  factory MessagesModel.fromJson(Map<String, dynamic> json) {
    return MessagesModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      subject: json['subject'],
      message: json['message'],
      status: json['status'],
    );
  }
}
