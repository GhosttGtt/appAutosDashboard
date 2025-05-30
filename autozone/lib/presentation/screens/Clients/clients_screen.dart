import 'package:flutter/material.dart';

class ClientsScreen extends StatelessWidget {
  const ClientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
      ),
      body: const Center(
        child: Text(
          'Aquí se mostrarán los clientes',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
