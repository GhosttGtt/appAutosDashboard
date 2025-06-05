// ignore_for_file: avoid_print, deprecated_member_use

import 'package:autozone/presentation/theme/colors.dart';
import 'package:flutter/material.dart';

import 'package:autozone/core/services/api_global.dart';
import 'package:autozone/data/models/sales_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';

// Widget principal
class MonthlySalesChart extends StatefulWidget {
  final String selectedMonth;
  const MonthlySalesChart({super.key, required this.selectedMonth});

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
      final decoded = json.decode(response.body);
      final List<dynamic> jsonData = decoded is List
          ? decoded
          : (decoded['data'] ?? decoded['results'] ?? []);
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

        int selectedMonthIndex = _monthNameToNumber(widget.selectedMonth);
        final Map<String, int> brandCount = {};
        for (var sale in data) {
          final date = DateTime.tryParse(sale.date_sale);
          if (date != null && date.month == selectedMonthIndex) {
            final brand =
                sale.cars_name.isNotEmpty ? sale.cars_name : 'Sin marca';
            brandCount[brand] = (brandCount[brand] ?? 0) + 1;
          }
        }
        final brandKeys = brandCount.keys.toList();
        final maxCount = brandCount.values.isNotEmpty
            ? brandCount.values.reduce((a, b) => a > b ? a : b)
            : 1;
        // Encontrar el valor máximo para resaltar la barra
        int maxValue = 0;
        if (brandCount.isNotEmpty) {
          maxValue = brandCount.values.reduce((a, b) => a > b ? a : b);
        }
        final barGroups = List.generate(brandKeys.length, (index) {
          final brand = brandKeys[index];
          final isMax = brandCount[brand] == maxValue && maxValue > 0;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: brandCount[brand]!.toDouble(),
                color: isMax
                    ? autoPrimaryColor
                    : autoPrimaryColor.withOpacity(0.25),
                width: 42,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
            ],
            showingTooltipIndicators: [1],
          );
        });

        final totalVentasMes = data.where((sale) {
          final date = DateTime.tryParse(sale.date_sale);
          return date != null && date.month == selectedMonthIndex;
        }).fold<double>(
            0.0, (sum, sale) => sum + (double.tryParse(sale.total) ?? 0.0));
        return Column(
          children: [
            SizedBox(
              height: 220,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: (maxCount + 1),
                  minY: 0,
                  gridData: FlGridData(
                    show: false,
                    drawVerticalLine: false,
                    drawHorizontalLine: true,
                    horizontalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: autoGray300,
                        strokeWidth: 0.5,
                      );
                    },
                  ),
                  barGroups: barGroups,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < brandKeys.length) {
                            return Text(
                              brandKeys[index],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                color: autoGray300,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          return const Text('Sin ventas');
                        },
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < brandKeys.length) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Text(
                                brandCount[brandKeys[index]].toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Monto total vendido:  Q ${totalVentasMes.toStringAsFixed(2)}',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: autoGray900),
            ),
          ],
        );
      },
    );
  }

  int _monthNameToNumber(String monthName) {
    const months = [
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
    return months.indexOf(monthName) + 1;
  }
}
