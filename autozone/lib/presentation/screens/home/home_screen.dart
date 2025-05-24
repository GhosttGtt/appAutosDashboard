import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String username;
  //final String role;
  final String joinDate;
  final String photo;

  const HomeScreen({
    super.key,
    required this.username,
    //required this.role,
    required this.joinDate,
    required this.photo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Cierra sesión y vuelve al login
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(photo),
            ),
            const SizedBox(height: 16),
            Text(
              username,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            //Text(role),
            const SizedBox(height: 8),
            Text('Miembro desde: $joinDate'),
            const SizedBox(height: 24),
            const Text('Aquí puedes mostrar gráficas, cards, etc.'),
          ],
        ),
      ),
    );
  }
}

