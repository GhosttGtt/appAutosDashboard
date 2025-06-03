// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:autozone/core/services/api_global.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';

import 'package:autozone/core/services/api_global.dart';
import 'package:autozone/presentation/theme/colors.dart';
import 'package:autozone/presentation/theme/fonts.dart';
import 'package:autozone/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  bool showUpdateFields = false;

  @override
  void dispose() {
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
          SnackBar(
              content: Text(data['message'] ?? 'Error al enviar el correo')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de red: ${e.toString()}')),
      );
    }
  }

  void updatePassword(
      String usuario, String contrasenaTemporal, String nuevaContrasena) async {
    if (usuario.isEmpty ||
        contrasenaTemporal.isEmpty ||
        nuevaContrasena.isEmpty) {
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
          SnackBar(
              content:
                  Text(data['message'] ?? 'Error al actualizar la contraseña')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  void sendRecoveryEmail() async {
    setState(() {
    });
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor ingresa tu correo electrónico')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('${Api.apiUrl}${Api.recover}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      final data = jsonDecode(response.body);
      print(data);
      if (data['status_code'] == 200) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Recuperación de contraseña',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                      'Se ha enviado un enlace de recuperación de contraseña a tu dirección de correo electrónico:'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: autoGray400,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: Text(
                      _emailController.text,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRoutes.splash, (route) => false);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: autoPrimaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Aceptar',
                      style: TextStyle(
                          fontFamily: appFontFamily,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        setState(() {
          showUpdateFields = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${data['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ocurrió un error: $e')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }
    setState(() {
      _isLoading = false;
    });
  }

  void updatePassword() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Contraseña actualizada con éxito')),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).viewInsets.bottom -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/images/logoGris.png',
                            width: 275,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                'Recuperar contraseña',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),
                            Text(
                              'Correo electrónico',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontFamily: appFontFamily,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: autoGray900,
                              ),
                            ),
                            TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText: 'Correo electrónico'),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed:
                                    _isLoading ? null : sendRecoveryEmail,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: autoPrimaryColor,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: _isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white)
                                    : Text(
                                        'Recuperar contraseña',
                                        style: TextStyle(
                                            fontFamily: appFontFamily,
                                            fontSize: 18,
                                            color: Colors.white),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: autoGray400,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Cancelar',
                                  style: TextStyle(
                                      fontFamily: appFontFamily,
                                      fontSize: 18,
                                      color: autoGray600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
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
}
