import 'package:flutter/material.dart';
import 'package:autozone/data/models/car_model.dart';
import 'package:autozone/core/services/api_global.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  String? brand;

  @override
  void initState() {
    super.initState();
    fetchCars();
  }

  Future<void> fetchCars() async {
    final response = await http.get(Uri.parse('${Api.apiUrl}${Api.cars}'));
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      brand = prefs.getString('brand') ?? '';
      loading = true;
    });

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
      appBar: AppBar(
          title: const Text('Productos'),
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: cars.length,
              itemBuilder: (context, index) => Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                color: Colors.white,
                child: ListTile(
                  leading: Image.network(cars[index].image,
                      width: 100, fit: BoxFit.cover),
                  title: Text(cars[index].brand),
                  subtitle: Text('${cars[index].description}'
                      '\nMarca: ${cars[index].brand}'
                      '\nModelo: ${cars[index].model}'
                      '\nAño: ${cars[index].year}'),
                  trailing: Text(
                    'Precio: \$${cars[index].price}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ),
              ),
            ),
    );
  }
}
