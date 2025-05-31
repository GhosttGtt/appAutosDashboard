import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:convert';

// Simula una respuesta del servidor (para que puedas probarlo sin conexión a una API real)
const mockJson = '''
{
  "data": [
    {"payment_type": "Efectivo", "count": 10},
    {"payment_type": "Tarjeta", "count": 5},
    {"payment_type": "Transferencia", "count": 8}
  ]
}
''';

class PaymentSales {
  final String paymentType;
  final int count;

  PaymentSales(this.paymentType, this.count);

  factory PaymentSales.fromJson(Map<String, dynamic> json) {
    return PaymentSales(
      json['payment_type'],
      json['count'],
    );
  }
}

class PaymentSalesChart extends StatelessWidget {
  const PaymentSalesChart({super.key});

  Future<List<PaymentSales>> fetchPaymentSales() async {
    // Simulando la llamada a tu API
    await Future.delayed(const Duration(seconds: 2)); // simulación de espera
    final data = jsonDecode(mockJson);
    final sales = data['data'] as List;
    return sales.map((e) => PaymentSales.fromJson(e)).toList();
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
              ),
            ],
          );
        }
      },
    );
  }
}
