import 'package:flutter/material.dart';
import 'package:autozone/core/services/api_global.dart';
import 'package:autozone/data/models/sales_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:autozone/routes/routes.dart';
import 'package:fl_chart/fl_chart.dart';
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

  String? selectedMonth = 'Todos';
  String? selectedBrand = 'Todos';
  String? selectedModel = 'Todos';

  List<String> get brands =>
      ['Todos', ...sales.map((s) => s.cars_name).toSet()];
  List<String> get models =>
      ['Todos', ...sales.map((s) => s.cars_model).toSet()];
  List<String> get months => [
        'Todos',
        'Enero',
        'Febrero',
        'Marzo',
        'Abril',
        'Mayo',
        'Junio',
        'Julio',
        'Agosto',
        'Septiembre',
        'Octubre',
        'Noviembre',
        'Diciembre'
      ];

  List<SalesModel> _filteredSales() {
    return sales.where((sale) {
      final saleDate = DateTime.tryParse(sale.date_sale);
      final monthMatch = selectedMonth == null ||
          selectedMonth == 'Todos' ||
          (saleDate != null && months[saleDate.month] == selectedMonth);
      final brandMatch = selectedBrand == null ||
          selectedBrand == 'Todos' ||
          sale.cars_name == selectedBrand;
      final modelMatch = selectedModel == null ||
          selectedModel == 'Todos' ||
          sale.cars_model == selectedModel;
      return monthMatch && brandMatch && modelMatch;
    }).toList();
  }

  List<BarChartGroupData> _getBarGroups() {
    final filtered = _filteredSales();
    final modelCounts = <String, int>{};
    for (var sale in filtered) {
      modelCounts[sale.cars_model] = (modelCounts[sale.cars_model] ?? 0) + 1;
    }
    final models = modelCounts.keys.toList();
    return List.generate(models.length, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: modelCounts[models[i]]!.toDouble(),
            color: Colors.purple,
            width: 18,
          ),
        ],
      );
    });
  }

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
        title: const Text('Vehiculos vendidos'),
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
        child: Column(
          children: [
            if (!loading && sales.isNotEmpty)
              SizedBox(
                height: 220,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    barGroups: _getBarGroups(),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            // Solo muestra números enteros
                            if (value % 1 == 0) {
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(fontSize: 10),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, _) {
                            final idx = value.toInt();
                            final models = _filteredSales()
                                .map((s) => s.cars_model)
                                .toSet()
                                .toList();
                            return Text(models[idx],
                                style: const TextStyle(fontSize: 10));
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            // --- FILTROS ---
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text('Mes'),
                    value: selectedMonth,
                    items: months
                        .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                        .toList(),
                    onChanged: (v) => setState(() => selectedMonth = v),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text('Marca'),
                    value: selectedBrand,
                    items: brands
                        .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                        .toList(),
                    onChanged: (v) => setState(() => selectedBrand = v),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text('Modelo'),
                    value: selectedModel,
                    items: models
                        .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                        .toList(),
                    onChanged: (v) => setState(() => selectedModel = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // --- LISTA ---
            loading
                ? const Center(child: CircularProgressIndicator())
                : _filteredSales().isEmpty
                    ? const Center(child: Text('No hay ventas registradas'))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _filteredSales().length,
                        itemBuilder: (context, index) {
                          final sale = _filteredSales()[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 5.0),
                            child: ListTile(
                              title:
                                  Text('${sale.cars_name} ${sale.cars_model}'),
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
                      ),
          ],
        ),
      ),
    );
  }
}
