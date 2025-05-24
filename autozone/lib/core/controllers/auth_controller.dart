import 'package:autozone/core/services/api_service.dart';

class AuthController {
  static Future<Map<String, dynamic>> loginUser(String username, String password) async {
    final response = await ApiService.loginUser(username, password);

    if (response['success'] == true) {
      return response;
    } else {
      throw Exception(response['message'] ?? 'Error de autenticación');
    }
  }
}
