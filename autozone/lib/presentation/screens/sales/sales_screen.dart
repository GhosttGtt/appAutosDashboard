import 'package:flutter/material.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevas Ventas'),
      ),
      body: const Center(
        child: Text(
          'Aquí se mostrarán las nuevas ventas',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
