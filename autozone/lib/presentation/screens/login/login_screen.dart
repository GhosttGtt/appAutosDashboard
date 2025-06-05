// ignore_for_file: avoid_print, unnecessary_null_comparison, use_build_context_synchronously

import 'package:autozone/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:autozone/presentation/theme/colors.dart';
import 'package:autozone/presentation/theme/fonts.dart';
import 'package:autozone/presentation/screens/forgot_password/forgot_password_screen.dart';
import 'package:autozone/core/controllers/auth_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false;
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);
    try {
      final result = await AuthController.loginUser(
        _usernameController.text,
        _passwordController.text,
      );

      if (!mounted) return;
      print(result);
      if (result != null && result['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', result['token']);
        await prefs.setString('userId', result['user']['id'].toString());
        await prefs.setString('username', result['user']['username']);
        await prefs.setString('name', result['user']['name']);
        await prefs.setString('email', result['user']['email']);
        await prefs.setString('photo', result['user']['img']);
        await prefs.setString('role', result['user']['role']);
      }
      Navigator.pushReplacementNamed(context, AppRoutes.splash);
    } catch (e) {
      print(e);
      if (!mounted) return;
      String errorMsg = e.toString();
      if (errorMsg.startsWith('Exception:')) {
        errorMsg = errorMsg.replaceFirst('Exception:', '').trim();
      }
      if (errorMsg.startsWith('ClientException')) {
        errorMsg = "Verifica tu conexión a internet.";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              errorMsg,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: Colors.red,
          elevation: 2,
          padding: EdgeInsets.only(top: 10, bottom: 15),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        ), // Logo de la aplicación
                        const SizedBox(height: 30),
                        Center(
                          child: Text(
                            'Iniciar sesión',
                            style: TextStyle(
                              fontFamily: appFontFamily,
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: autoGray900,
                            ),
                          ),
                        ), // Título del inicio de sesión
                        const SizedBox(height: 20),
                        Text(
                          'Usuario',
                          style: TextStyle(
                            fontFamily: appFontFamily,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: autoGray900,
                          ),
                        ), // Etiqueta de usuario
                        TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: autoGray200,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            hintText: 'Nombre de usuario',
                          ),
                        ), // Campo de texto para el usuario
                        const SizedBox(height: 20),
                        Text(
                          'Contraseña',
                          style: TextStyle(
                            fontFamily: appFontFamily,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: autoGray900,
                          ),
                        ), // Etiqueta de contraseña

                        TextField(
                          controller: _passwordController,
                          obscureText: !_showPassword,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: autoGray200,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            hintText: 'Ingresar contraseña',
                          ),
                        ), // Campo de texto para la contraseña
                        Row(
                          children: [
                            Checkbox(
                              value: _showPassword,
                              onChanged: (value) {
                                setState(() {
                                  _showPassword = value!;
                                });
                              },
                            ),
                            Text(
                              'Mostrar contraseña',
                              style: TextStyle(
                                fontFamily: appFontFamily,
                                fontSize: 16,
                                color: autoGray900,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                            height: 25), // Opción para mostrar la contraseña
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: autoPrimaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 20,
                              ),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : Text(
                                    'Ingresar',
                                    style: TextStyle(
                                      fontFamily: appFontFamily,
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ), // Botón de inicio de sesión

                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ForgotPasswordScreen(),
                              ),
                            );
                          },
                          child: Text(
                            '¿Olvidaste tu contraseña?',
                            style: TextStyle(
                              fontFamily: appFontFamily,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: autoGray900,
                              decoration: TextDecoration.underline,
                              height: 3.5,
                            ),
                          ),
                        ), // Enlace para recuperar contraseña
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '¿No tienes una cuenta?',
                                style: TextStyle(
                                  color: autoGray900,
                                  fontFamily: appFontFamily,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    AppRoutes.register,
                                  );
                                },
                                child: Text(
                                  'Registrate',
                                  style: TextStyle(
                                    color: autoPrimaryColor,
                                    fontFamily: appFontFamily,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.underline,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ), // Enlace para registrarse
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
