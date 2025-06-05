// ignore_for_file: non_constant_identifier_names

class SalesModel {
  final int id;
  final int client_id;
  final String client_name;
  final String client_lastname;
  final int cars_id;
  final String cars_name;
  final String cars_model;
  final int cars_year;
  final String cars_motor;
  final String cars_fuel;
  final String cars_price;
  final String cars_image;
  final String cars_type;
  final String total; //revisar con Alex si es double o int
  final int payment_id;
  final String payment;
  final String date_sale;
  final int status_id;

  SalesModel({
    required this.id,
    required this.client_id,
    required this.client_name,
    required this.client_lastname,
    required this.cars_id,
    required this.cars_name,
    required this.cars_model,
    required this.cars_year,
    required this.cars_motor,
    required this.cars_fuel,
    required this.cars_price,
    required this.cars_image,
    required this.cars_type,
    required this.total,
    required this.payment_id,
    required this.payment,
    required this.date_sale,
    required this.status_id,
  });

  factory SalesModel.fromJson(Map<String, dynamic> json) {
    return SalesModel(
      id: int.parse(json['id'].toString()),
      client_id: int.parse(json['client_id'].toString()),
      client_name: json['client_name'],
      client_lastname: json['client_lastname'],
      cars_id: int.parse(json['cars_id'].toString()),
      cars_name: json['cars_name'],
      cars_model: json['cars_model'],
      cars_year: int.parse(json['cars_year'].toString()),
      cars_motor: json['cars_motor'],
      cars_fuel: json['cars_fuel'],
      cars_price: json['cars_price'],
      cars_image: json['cars_image'],
      cars_type: json['cars_type'],
      total: json['total'],
      payment_id: int.parse(json['payment_id'].toString()),
      payment: json['payment'],
      date_sale: json['date_sale'],
      status_id: int.parse(json['status_id'].toString()),
    );
  }

  static List<SalesModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((item) => SalesModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
