import 'package:autozone/presentation/screens/home/home_screen.dart';
import 'package:autozone/presentation/screens/init/splash.dart';
import 'package:autozone/presentation/screens/login/login_screen.dart';
import 'package:autozone/presentation/screens/products/products_screen.dart';
import 'package:autozone/presentation/screens/register/register_screen.dart';
import 'package:autozone/presentation/screens/sales/sales_screen.dart';
import 'package:autozone/presentation/screens/messages/new_messages.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String products = '/products';
  static const String home = '/home';
  static const String sales = '/sales';
  static const String newMessages = '/new_messages';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const Splash());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case sales:
        return MaterialPageRoute(builder: (_) => const SalesScreen());
      case newMessages:
        return MaterialPageRoute(
          builder: (_) => const NewMessagesScreen(),
        );
      case products:
        return MaterialPageRoute(
          builder: (_) => const ProductsScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
