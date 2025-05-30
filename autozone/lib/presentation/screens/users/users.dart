import 'package:flutter/material.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios'),
      ),
      body: const Center(
        child: Text(
          'Aquí se mostrarán los usuarios',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
