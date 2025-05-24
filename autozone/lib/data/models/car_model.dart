// data/models/car_model.dart
class CarModel {
  final String name;
  final String image;
  final double price;

  CarModel({required this.name, required this.image, required this.price});

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      name: json['nombre'],
      image: json['foto'],
      price: double.tryParse(json['precio']) ?? 0,
    );
  }
}
