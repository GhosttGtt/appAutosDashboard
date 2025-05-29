import 'package:flutter/material.dart';
import 'package:autozone/core/services/api_global.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _tempPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  bool showUpdateFields = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _tempPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

void sendRecoveryEmail() async {
  final usuario = _usernameController.text.trim();
  final email = _emailController.text.trim();

  if (usuario.isEmpty || email.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Por favor completa usuario y correo')),
    );
    return;
  }

  final url = Uri.parse('${Api.apiUrl}${Api.resetPassword}');

  try {
    final response = await http.post(
      url,
      body: {
        'usuario': usuario,
        'correo': email,
      },
    );

    final data = json.decode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      setState(() {
        showUpdateFields = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Correo enviado con la contraseña temporal')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? 'Error al enviar el correo')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error de red: ${e.toString()}')),
    );
  }
}


  void updatePassword(String usuario, String contrasenaTemporal, String nuevaContrasena) async {
    if (usuario.isEmpty || contrasenaTemporal.isEmpty || nuevaContrasena.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    final url = Uri.parse('${Api.apiUrl}${Api.resetPassword}');

    try {
      final response = await http.post(
        url,
        body: {
          'usuario': usuario,
          'contrasena_temporal': contrasenaTemporal,
          'nueva_contrasena': nuevaContrasena,
        },
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Contraseña actualizada con éxito')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Error al actualizar la contraseña')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recuperar contraseña")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Usuario'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Correo electrónico'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: sendRecoveryEmail,
              child: Text('Enviar contraseña temporal'),
            ),
            if (showUpdateFields) ...[
              SizedBox(height: 20),
              TextField(
                controller: _tempPasswordController,
                decoration: InputDecoration(labelText: 'Contraseña temporal'),
                obscureText: true,
              ),
              TextField(
                controller: _newPasswordController,
                decoration: InputDecoration(labelText: 'Nueva contraseña'),
                obscureText: true,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => updatePassword(
                  _usernameController.text,
                  _tempPasswordController.text,
                  _newPasswordController.text,
                ),
                child: Text('Actualizar contraseña'),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
