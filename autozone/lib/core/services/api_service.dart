import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<bool> loginUser(String username, String password) async {
    final url = Uri.parse('https://alexcg.de/autozone/api/login.php');
    final response = await http.post(url, body: {
      'username': username,
      'password': password,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['success'] == true;
    } else {
      return false;
    }
  }
}

