import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:autozone/routes/routes.dart';
import 'package:autozone/presentation/widgets/custom_drawer.dart';
import 'package:autozone/core/services/api_global.dart';

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
  String? role;
  String currentTime = '';
  String selectedMonth = 'Enero';

  Timer? _timer;

  final List<String> months = [
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

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _startClock();
  }

  void _startClock() {
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      currentTime = "${now.day.toString().padLeft(2, '0')}-"
          "${now.month.toString().padLeft(2, '0')}-"
          "${now.year} "
          "${now.hour.toString().padLeft(2, '0')}:"
          "${now.minute.toString().padLeft(2, '0')}:"
          "${now.second.toString().padLeft(2, '0')}";
    });
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      name = prefs.getString('name');
      photo = prefs.getString('photo');
      email = prefs.getString('email');
      role = prefs.getString('role');
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      // AppBar superior con íconos
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('Inicio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.message),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.newMessages);
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.sales);
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('token');
              Navigator.pushReplacementNamed(context, AppRoutes.splash);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Ficha de usuario estilo tarjeta
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: (photo != null && photo!.isNotEmpty)
                          ? NetworkImage(photo!)
                          : const AssetImage('assets/images/default.png')
                              as ImageProvider,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name ?? '',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(role ?? '',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey)),
                          Text(email ?? '',
                              style: const TextStyle(color: Colors.grey)),
                          Text("Último acceso: $currentTime",
                              style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Tarjetas: Nuevas ventas y Nuevos mensajes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.sales),
                    child: Card(
                      color: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: SizedBox(
                        height: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.shopping_cart, color: Colors.purple),
                            SizedBox(height: 8),
                            Text('Nuevas ventas')
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.newMessages),
                    child: Card(
                      color: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: SizedBox(
                        height: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.message, color: Colors.purple),
                            SizedBox(height: 8),
                            Text('Nuevos mensajes')
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Tarjeta: Tendencia de ventas con DropDown
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.trending_up, color: Colors.black54),
                        SizedBox(width: 8),
                        Text("Tendencia de ventas",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: selectedMonth,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedMonth = newValue!;
                          // Aquí puedes hacer la petición a la API por mes
                        });
                      },
                      items: months.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    // Aquí irá el grafico de ventas por mes
                    Container(
                      height: 250,
                      alignment: Alignment.center,
                      child: const Text(
                        'Aquí va el gráfico de ventas (en desarrollo)',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
