import 'package:flutter/material.dart';
import 'package:autozone/core/services/api_global.dart';
import 'package:autozone/data/models/sales_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:autozone/routes/routes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  List<SalesModel> sales = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    salesData();
  }

  Future<void> salesData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final response = await http.get(
      Uri.parse('${Api.apiUrl}${Api.sales}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    await SharedPreferences.getInstance();

    setState(() {
      sales = [];
      loading = true;
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List rawSales = jsonData['data'] ?? [];
      sales = rawSales.map((json) => SalesModel.fromJson(json)).toList();

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
        title: const Text('Clientes'),
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
        ],
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: loading
              ? const Center(child: CircularProgressIndicator())
              : sales.isEmpty
                  ? const Center(child: Text('No hay ventas registradas'))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: sales.length,
                      itemBuilder: (context, index) {
                        final sale = sales[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 5.0),
                          child: ListTile(
                            title: Text('${sale.cars_name} ${sale.cars_model}'),
                            subtitle: Text(
                                'Cliente: ${sale.client_name} ${sale.client_lastname}\nFecha de venta: ${sale.date_sale}\nTotal: \$${sale.total}'),
                            leading: sale.cars_image.isNotEmpty
                                ? CircleAvatar(
                                    radius: 40,
                                    child: ClipOval(
                                      child: Image.network(
                                        'https://alexcg.de/autozone/img/cars/${sale.cars_image}',
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
