import 'package:flutter/material.dart';
import 'package:autozone/data/models/car_model.dart';
import 'package:autozone/presentation/widgets/product_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<CarModel> cars = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchCars();
  }

Future<void> fetchCars() async {
  final response = await http.get(Uri.parse('https://alexcg.de/autozone/api/cars.php'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = json.decode(response.body);
    final List rawCars = jsonData['data'] ?? []; //
    cars = rawCars.map((json) => CarModel.fromJson(json)).toList();

    setState(() {
      loading = false;
    });
  } else {
    setState(() => loading = false);
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Productos'), backgroundColor: Colors.purple),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: cars.length,
              itemBuilder: (context, index) => Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: Image.network(cars[index].image, width: 60, fit: BoxFit.cover),
                  title: Text(cars[index].brand),
                ),
              ),
            ),
    );
  }
}
