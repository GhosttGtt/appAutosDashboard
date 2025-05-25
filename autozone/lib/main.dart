import 'package:flutter/material.dart';
import 'routes/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Autozone',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash, // Mostrar pantalla de login al iiar
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}