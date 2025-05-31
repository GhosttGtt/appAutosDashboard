import 'package:flutter/material.dart';

import 'package:autozone/core/services/api_global.dart';
import 'package:autozone/data/models/sales_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';

// Widget principal
class MonthlySalesChart extends StatefulWidget {
  const MonthlySalesChart({super.key});

  @override
  State<MonthlySalesChart> createState() => _MonthlySalesChartState();
}

class _MonthlySalesChartState extends State<MonthlySalesChart> {
  late Future<List<SalesModel>> _salesFuture;

  @override
  void initState() {
    super.initState();
    _salesFuture = fetchSalesData();
  }

  Future<List<SalesModel>> fetchSalesData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await http.get(
      Uri.parse('${Api.apiUrl}${Api.sales}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => SalesModel.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar las ventas');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SalesModel>>(
      future: _salesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hay datos disponibles'));
        }

        final data = snapshot.data!;
        final spots = List.generate(data.length, (index) {
          return FlSpot(index.toDouble(), data[index].total);
        });

        return SizedBox(
          height: 250,
          child: LineChart(
            LineChartData(
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < data.length) {
                        return Text(data[index]
                            .date_sale
                            .substring(0, 3)); // Ene, Feb, etc.
                      }
                      return const Text('');
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: true),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(
                      show: true, color: Colors.blue.withOpacity(0.3)),
                  color: Colors.blue,
                  barWidth: 3,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
