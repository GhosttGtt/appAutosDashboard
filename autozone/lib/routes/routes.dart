import 'package:autozone/presentation/screens/home/home_screen.dart';
import 'package:autozone/presentation/screens/init/splash.dart';
import 'package:autozone/presentation/screens/login/login_screen.dart';
import 'package:autozone/presentation/screens/products/products_screen.dart';
import 'package:autozone/presentation/screens/register/register_screen.dart';
import 'package:autozone/presentation/screens/sales/sales_screen.dart';
import 'package:autozone/presentation/screens/messages/new_messages.dart';
import 'package:autozone/presentation/screens/users/users.dart';
import 'package:autozone/presentation/screens/users/edit_users.dart';
import 'package:autozone/presentation/screens/clients/clients_screen.dart';
import 'package:autozone/presentation/screens/users/edit_all_users.dart';
import 'package:autozone/presentation/screens/Clients/edit_clients.dart';
import 'package:autozone/presentation/widgets/add_product.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String products = '/products';
  static const String home = '/home';
  static const String sales = '/sales';
  static const String newMessages = '/new_messages';
  static const String editUser = '/edit_user';
  static const String user = '/users';
  static const String clients = '/clients_screen';
  static const String editAllUser = '/edit_all_user';
  static const String editClients = '/edit_clients';
  static const String addProduct = '/add_product';
  static const String addVehicule = '/add_vehicule';

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
      case clients:
        return MaterialPageRoute(builder: (_) => const ClientsScreen());
      case newMessages:
        return MaterialPageRoute(
          builder: (_) => const NewMessagesScreen(),
        );
      case editUser:
        return MaterialPageRoute(builder: (_) => const EditUserScreen());
      case editAllUser:
        final int userId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => EditAllUserScreen(id: userId),
        );
      case user:
        return MaterialPageRoute(builder: (_) => const UsersScreen());
      case editClients:
        return MaterialPageRoute(
          builder: (_) => EditClientsScreen(id: settings.arguments as int),
        );
      case products:
        return MaterialPageRoute(
          builder: (_) => const ProductsScreen(),
        );
      case addVehicule:
        return MaterialPageRoute(builder: (_) => const AddVehicule());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
