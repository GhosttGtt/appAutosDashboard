// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:autozone/core/services/api_global.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<Map<String, dynamic>> loginUser(
      String username, String password) async {
    final url = Uri.parse(Api.apiUrl + Api.login);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error en la conexión al servidor');
    }
  }

  static Future<Map<String, dynamic>> registerUser({
    required String name,
    required String username,
    required String email,
    required String password,
    required String role,
    String? dateAt,
  }) async {
    final uri = Uri.parse(Api.apiUrl + Api.register);
    /*var request = http.MultipartRequest('POST', uri);

     if (photo != null) {
      final mimeType = lookupMimeType(photo.path)!.split('/');
      request.files.add(await http.MultipartFile.fromPath(
        'photo', // o 'foto' si tu backend lo requiere
        photo.path,
        contentType: MediaType(mimeType[0], mimeType[1]),
        filename:
            photo.path.split(Platform.pathSeparator).last, // nombre del archivo
      ));
      // Si necesitas enviar el path/nombre de la foto en el JSON, agrégalo como un campo más:
      request.fields['photo_path'] =
          photo.path.split(Platform.pathSeparator).last;
    } */

    final Map<String, dynamic> body = {
      'name': name,
      'username': username,
      'email': email,
      'password': password,
      'role': role,
      if (dateAt != null) 'date_at': dateAt,
    };

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return {'success': false, 'message': response.body};
    }
  }
}
