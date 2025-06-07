class AppointmentModel {
  final int id;
  final String name;
  final String email;
  final String datetime;
  final int personas;

  AppointmentModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.datetime,
      required this.personas});

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      datetime: json['datetime'],
      personas: json['personas'],
    );
  }
}
