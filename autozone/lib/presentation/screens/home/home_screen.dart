import 'package:autozone/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:autozone/presentation/widgets/custom_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
      drawer: const CustomDrawer(), // 👈 Tu Drawer personalizado
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min, // 👈 Asegura que no tome todo el alto
              crossAxisAlignment: CrossAxisAlignment.center, // 👈 Centra horizontalmente
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: (photo != null && photo!.isNotEmpty)
                      ? NetworkImage(photo!)
                      : const AssetImage('assets/images/default.png') as ImageProvider,
                ),
                const SizedBox(height: 16),
                Text(
                  username ?? '',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  email ?? '',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text('Miembro desde: 25-05-2023'),
                const SizedBox(height: 24),
                const Text('Detalles de ventas'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
