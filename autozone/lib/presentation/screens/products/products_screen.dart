import 'package:flutter/material.dart';
import 'package:autozone/data/models/car_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:autozone/presentation/widgets/add_product.dart';
import 'package:autozone/core/services/api_global.dart';
import 'package:autozone/routes/routes.dart';
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
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final response = await http.get(
      Uri.parse('${Api.apiUrl}${Api.cars}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    await SharedPreferences.getInstance();

    setState(() {
      cars = [];
      loading = true;
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List rawCars = jsonData['data'] ?? [];
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
        centerTitle: true,
        title: const Text('Vehiculos'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            color: Colors.white,
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.home);
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            color: Colors.white,
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const AddVehicule(),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: loading
              ? const Center(child: CircularProgressIndicator())
              : cars.isEmpty
                  ? const Center(child: Text('No hay vehiculos registrados'))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cars.length,
                      itemBuilder: (context, index) {
                        final car = cars[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 5.0),
                          child: ListTile(
                            title: Text('${car.brand} ${car.model}'),
                            subtitle: Text(
                                'Descripción: ${car.description} \nAño: ${car.year}\nmotor:${car.motor}\nTipo: ${car.type}\nPrecio: \$${car.price}\nEn existencia: ${car.stock}'),
                            leading: car.image.isNotEmpty
                                ? CircleAvatar(
                                    radius: 40,
                                    child: ClipOval(
                                      child: Image.network(
                                        car.image,
                                        fit: BoxFit.cover,
                                        width: 80,
                                        height: 80,
                                      ),
                                    ),
                                  )
                                : const CircleAvatar(
                                    child: Icon(Icons.car_rental),
                                  ),
                          ),
                        );
                      },
                    )),
    );
  }
}
