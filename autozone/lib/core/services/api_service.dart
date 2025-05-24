import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _loginUrl = 'https://alexcg.de/autozone/api/login.php';

  static Future<bool> loginUser(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(_loginUrl),
        body: {
          'usuario': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true || data['success'] == 1;
      } else {
        return false;
      }
    } catch (e) {
      print('Error al hacer login: $e');
      return false;
    }
  }
}
