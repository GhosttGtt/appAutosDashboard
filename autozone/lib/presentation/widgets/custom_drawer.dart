// presentation/widgets/custom_drawer.dart
import 'package:autozone/presentation/screens/sales/sales_screen.dart';
import 'package:flutter/material.dart';
import 'package:autozone/presentation/screens/products/products_screen.dart';
import 'package:autozone/presentation/screens/clients/clients_screen.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:autozone/presentation/screens/users/users.dart';
import 'package:autozone/presentation/screens/messages/new_messages.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String? username;
  String? name;
  String? photo;
  String? email;
  String? role;

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
      role = prefs.getString('role');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.70,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.purple),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: (photo != null && photo!.isNotEmpty)
                      ? NetworkImage(photo!)
                      : const AssetImage('assets/images/default.png')
                          as ImageProvider,
                ),
                const SizedBox(height: 8),
                const Text('Menú',
                    style: TextStyle(color: Colors.white, fontSize: 24)),
              ],
            ),
          ),
          _drawerItem(context, 'Usuarios', Icons.person, () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const UsersScreen()));
          }),
          _drawerItem(context, 'Clientes', Icons.people, () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ClientsScreen()));
          }),
          _drawerItem(context, 'Ventas', Icons.attach_money, () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const SalesScreen()));
          }),
          _drawerItem(context, 'Vehiculos', Icons.car_rental, () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ProductsScreen()));
          }),
          _drawerItem(context, 'Mensajes', Icons.message, () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const NewMessagesScreen()));
          }),
        ],
      ),
    );
  }

  ListTile _drawerItem(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
