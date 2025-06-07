import 'package:flutter/material.dart';
import 'routes/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Autozone',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash, // Mostrar pantalla de login al iiar
      onGenerateRoute: AppRoutes.generateRoute,
      navigatorObservers: [routeObserver],
    );
  }
}
