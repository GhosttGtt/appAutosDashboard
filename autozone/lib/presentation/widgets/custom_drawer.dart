// presentation/widgets/custom_drawer.dart
import 'package:flutter/material.dart';
import 'package:autozone/presentation/screens/products/products_screen.dart';


class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.purple),
            child: Text('Menú', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          _drawerItem(context, 'Usuarios', Icons.person, () {/* Navegar */}),
          _drawerItem(context, 'Clientes', Icons.people, () {/* Navegar */}),
          _drawerItem(context, 'Ventas', Icons.attach_money, () {/* Navegar */}),
          _drawerItem(context, 'Productos', Icons.car_rental, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductsScreen()));
          }),
          _drawerItem(context, 'Mensajes', Icons.message, () {/* Navegar */}),
        ],
      ),
    );
  }

  ListTile _drawerItem(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
