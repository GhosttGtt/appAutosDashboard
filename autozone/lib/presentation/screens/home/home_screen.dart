// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:autozone/presentation/widgets/menu.dart';
import 'package:autozone/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:autozone/presentation/widgets/custom_drawer.dart';
import 'package:autozone/presentation/theme/colors.dart';
import 'package:autozone/core/services/api_global.dart';
import 'package:autozone/presentation/widgets/monthly_sales_chart.dart';
import 'package:http/http.dart' as http;
import 'package:autozone/data/models/sales_model.dart';

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
  Timer? _timer;
  String selectedMonth = 'Enero';
  String countNewMessages = '0';
  String countNewSales = '0';

  late Future<List<String>> messagesFuture;

  Future<List<String>> fetchMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await http.get(
      Uri.parse('${Api.apiUrl}${Api.messages}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 401) {
      await prefs.remove('token');
      Navigator.pushReplacementNamed(context, AppRoutes.splash);
      return [];
    }
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List<dynamic> rawMessages = jsonData['data'] ?? [];
      final int count = rawMessages.where((msg) {
        if (msg is Map<String, dynamic>) {
          return msg['status'] == 0;
        }
        if (msg is Map) {
          return msg['status'] == 0;
        }
        return false;
      }).length;
      setState(() {
        countNewMessages = count.toString();
      });
      return rawMessages.map((item) => item.toString()).toList();
    } else {
      throw Exception('Error al cargar los mensajes');
    }
  }

  late Future<List<SalesModel>> salesFuture;

  Future<List<SalesModel>> fetchSalesData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await http.get(
      Uri.parse('${Api.apiUrl}${Api.sales}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 401) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');

      SnackBar(
        content: Text('Sesión expirada, por favor inicia sesión nuevamente.'),
      );

      Navigator.pushReplacementNamed(context, AppRoutes.splash);
      return [];
    }
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List<dynamic> rawSales = jsonData['data'] ?? [];
      final int count = rawSales.where((msg) {
        if (msg is Map<String, dynamic>) {
          return msg['status_id'] == 1;
        }
        if (msg is Map) {
          return msg['status_id'] == 1;
        }
        return false;
      }).length;
      setState(() {
        countNewSales = count.toString();
      });

      return rawSales.map((item) => SalesModel.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar las ventas');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _startClock();
    salesFuture = fetchSalesData();
    fetchMessages().then((messages) {
      setState(() {
        countNewMessages = messages.length.toString();
      });
    });
  }

  void _startClock() {
    _updateTime();
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
      endDrawer: const CustomDrawer(),
      backgroundColor: autoGray200,
      body: Column(
        children: [
          Menu(),
          Container(
            padding: const EdgeInsets.all(15),
            height: MediaQuery.of(context).size.height - 100,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 1,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: CircleAvatar(
                                    radius: 40,
                                    backgroundImage:
                                        (photo != null && photo!.isNotEmpty)
                                            ? NetworkImage(photo!)
                                            : const AssetImage(
                                                    'assets/images/default.png')
                                                as ImageProvider,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: const Icon(Icons.edit_note_outlined,
                                      color: autoGray900),
                                  onPressed: () async {
                                    await Navigator.pushNamed(
                                        context, AppRoutes.editUser);
                                    _loadUserData();
                                  },
                                ),
                              ),
                            ],
                          ),
                          Text(
                            name ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            role ?? '',
                            style: const TextStyle(
                              fontSize: 13,
                              color: autoGray300,
                            ),
                          ),
                          Text(
                            email ?? '',
                            style: const TextStyle(
                              fontSize: 13,
                              color: autoGray300,
                            ),
                          ),
                          Text(
                            "Último acceso: $currentTime",
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, AppRoutes.sales),
                          child: Card(
                            color: Colors.white,
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: Container(
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                                top: 36,
                                bottom: 16,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        child: Icon(
                                          Icons.shopping_cart_outlined,
                                          color: autoPrimaryColor,
                                          size: 60,
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          width: 32,
                                          height: 32,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.red,
                                          ),
                                          child: Center(
                                            child: Text(
                                              countNewSales,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Nuevas ventas',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.newMessages,
                          ),
                          child: Card(
                            color: Colors.white,
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: Container(
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                                top: 36,
                                bottom: 16,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        child: Icon(
                                          Icons.messenger_outline_sharp,
                                          color: autoPrimaryColor,
                                          size: 60,
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          width: 32,
                                          height: 32,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.red,
                                          ),
                                          child: Center(
                                            child: Text(
                                              countNewMessages,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Nuevos mensajes',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.directions_car_filled_outlined,
                                  size: 20, color: autoGray900),
                              const SizedBox(width: 2),
                              const Text(
                                'Tendencia de ventas',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: autoGray900,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                decoration: BoxDecoration(
                                  border: Border.all(color: autoGray400),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: DropdownButton<String>(
                                  isDense: true,
                                  menuWidth:
                                      MediaQuery.of(context).size.width * 0.5,
                                  menuMaxHeight: 300,
                                  focusColor: Colors.white,
                                  enableFeedback: true,
                                  underline: Container(),
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down_outlined,
                                    color: autoGray600,
                                  ),
                                  dropdownColor: Colors.white,
                                  style: const TextStyle(
                                    color: autoGray600,
                                    fontSize: 14,
                                  ),
                                  value: selectedMonth,
                                  items: [
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
                                  ]
                                      .map((month) => DropdownMenuItem(
                                          value: month, child: Text(month)))
                                      .toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() {
                                        selectedMonth = value;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            child:
                                MonthlySalesChart(selectedMonth: selectedMonth),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
