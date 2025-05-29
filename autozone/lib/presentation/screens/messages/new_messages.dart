import 'package:flutter/material.dart';

class NewMessagesScreen extends StatelessWidget {
  const NewMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevos Mensajes'),
      ),
      body: const Center(
        child: Text(
          'Paciencia joven aquí se mostrarán los nuevos mensajes',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
