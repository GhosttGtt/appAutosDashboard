// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously

import 'package:autozone/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? username;
  String? name;
  String? photo;
  String? email;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      name = prefs.getString('name');
      photo = prefs.getString('photo');
      email = prefs.getString('email');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('token');
              Navigator.pushReplacementNamed(context, AppRoutes.splash);
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
              backgroundImage: (photo != null && photo!.isNotEmpty)
                  ? NetworkImage(photo!)
                  : const AssetImage('assets/images/default.png')
                      as ImageProvider,
            ),
            const SizedBox(height: 16),
            Text(
              '$username',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text('$email'),
            const SizedBox(height: 8),
            Text('Miembro desde: 25-05-2023'),
            const SizedBox(height: 24),
            const Text('Detalles de ventas'),
          ],
        ),
      ),
    );
  }
}
