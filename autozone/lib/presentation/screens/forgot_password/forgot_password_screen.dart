// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:autozone/core/services/api_global.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:autozone/presentation/theme/colors.dart';
import 'package:autozone/presentation/theme/fonts.dart';
import 'package:autozone/routes/routes.dart';

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
    super.dispose();
  }

  void sendRecoveryEmail() async {
    setState(() {});
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

  @override
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
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
            ),
          ),
        ));
  }
}
