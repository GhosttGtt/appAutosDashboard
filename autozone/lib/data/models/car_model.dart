// data/models/car_model.dart

class CarModel {
  final int id;
  final String brand;
  final String model;
  final String description;
  final String year;
  final String motor;
  final String price;
  final String image;
  final String type;
  final int stock;

  CarModel({
    required this.id,
    required this.brand,
    required this.model,
    required this.description,
    required this.year,
    required this.motor,
    required this.price,
    required this.image,
    required this.type,
    required this.stock,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'],
      brand: json['brand'],
      model: json['model'],
      description: json['description'],
      year: json['year'].toString(),
      motor: json['motor'],
      price: json['price'],
      image: json['image'],
      type: json['type_name'],
      stock: json['stock'],
    );
  }
}

