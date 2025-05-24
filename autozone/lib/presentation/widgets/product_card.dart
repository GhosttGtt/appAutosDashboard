// presentation/widgets/product_card.dart
import 'package:flutter/material.dart';
import 'package:autozone/data/models/car_model.dart';

class ProductCard extends StatelessWidget {
  final CarModel car;

  const ProductCard({required this.car, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Image.network(car.image, width: 60, fit: BoxFit.cover),
        title: Text(car.name),
        subtitle: Text('\$${car.price.toStringAsFixed(2)}'),
      ),
    );
  }
}

