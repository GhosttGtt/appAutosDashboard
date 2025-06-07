// ignore_for_file: non_constant_identifier_names

class NewCarModel {
  final String brand;
  final String description;
  final String fuel;
  final String model;
  final String year;
  final String price;
  final String image;
  final int stock;

  NewCarModel({
    required this.brand,
    required this.description,
    required this.fuel,
    required this.model,
    required this.year,
    required this.price,
    required this.image,
    required this.stock,
  });

  factory NewCarModel.fromJson(Map<String, dynamic> json) {
    return NewCarModel(
      brand: json['brand'],
      model: json['model'],
      description: json['description'],
      year: json['year'].toString(),
      fuel: json['fuel'],
      price: json['price'],
      image: json['image'],
      stock: json['stock'],
    );
  }
}
