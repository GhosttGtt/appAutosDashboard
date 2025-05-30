import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:autozone/core/services/api_global.dart';

class PaymentSales {
  final String paymentType;
  final int count;

  PaymentSales(this.paymentType, this.count);
}

class PaymentSalesChart extends StatelessWidget {
  const PaymentSalesChart({super.key});

  Future<List<PaymentSales>> fetchPaymentSales() async {
    final response = await Api.post('sales.php', {});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final sales = data['data'] as List;
      return sales
          .map((e) => PaymentSales.fromJson(e))
          .groupByPayment(); // función que agrupa por tipo de pago
    } else {
      print(
          'Error response: ${response.body}'); // 👈 imprime el error del servidor
      throw Exception('error al cargar los datos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PaymentSales>>(
      future: fetchPaymentSales(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hay datos disponibles'));
        } else {
          final data = snapshot.data!;
          return SfCircularChart(
            title: ChartTitle(text: 'Ventas por tipo de pago'),
            legend: const Legend(isVisible: true),
            series: <CircularSeries>[
              PieSeries<PaymentSales, String>(
                dataSource: data,
                xValueMapper: (PaymentSales sales, _) => sales.paymentType,
                yValueMapper: (PaymentSales sales, _) => sales.count,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              )
            ],
          );
        }
      },
    );
  }
}
