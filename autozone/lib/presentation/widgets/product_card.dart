// presentation/widgets/product_card.dart
import 'package:flutter/material.dart';
import 'package:autozone/core/services/api_service.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late Future<List<dynamic>> _carsFuture;

  @override
  void initState() {
    super.initState();
    _carsFuture = ApiService.getCars();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Productos')),
      body: FutureBuilder<List<dynamic>>(
        future: _carsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final cars = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: cars.length,
            itemBuilder: (context, index) {
              final car = cars[index];
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 6,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(car['image'],
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover),
                      ),
                      const SizedBox(height: 12),
                      Text('${car['brand']} ${car['model']}',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text('Motor: ${car['motor']}'),
                      Text('Año: ${car['year']}'),
                      Text('Tipo: ${car['type_name']}'),
                      Text('Stock: ${car['stock']}'),
                      Text('Precio: \$${car['price']}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
