// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously, unused_local_variable, avoid_print, prefer_final_fields, unnecessary_import
import 'dart:ui';

import 'package:autozone/core/services/api_service.dart';
import 'package:autozone/presentation/theme/colors.dart';
import 'package:autozone/presentation/theme/fonts.dart';
import 'package:autozone/routes/routes.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;
  bool _isLoading = false;
  String? _selectedRole;
  final List<String> _roles = ['user', 'admin', 'vendedor'];

  Future<void> registerUser() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Por favor, completa todos los campos y selecciona una foto.')),
      );
      return;
    }

    try {
      final response = await ApiService.registerUser(
        name: _nameController.text,
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        role: _selectedRole ?? '',
      );

      if (response['success'] == true) {
        Navigator.pushReplacementNamed(
            context, AppRoutes.login); // Cambia '/login' por la ruta que desees
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuario registrado con éxito')),
        );
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('${response['message'] ?? 'al registrar usuario'}')),
        );
      }
    } catch (e) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
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
            child: Form(
              key: _formKey,
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
                  Center(
                    child: Text(
                      'Registrarse',
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
                    'Nombre completo',
                    style: TextStyle(
                      fontFamily: appFontFamily,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: autoGray900,
                    ),
                  ), // Etiq
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: autoGray200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Nombre completo',
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Campo requerido'
                        : null,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Usuario',
                    style: TextStyle(
                      fontFamily: appFontFamily,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: autoGray900,
                    ),
                  ),

                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: autoGray200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Usuario',
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Campo requerido'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Correo electrónico',
                    style: TextStyle(
                      fontFamily: appFontFamily,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: autoGray900,
                    ),
                  ), //
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: autoGray200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Correo electrónico',
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Campo requerido'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Selecciona un rol',
                    style: TextStyle(
                      fontFamily: appFontFamily,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: autoGray900,
                    ),
                  ), //
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: autoGray200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Nombre de usuario',
                    ),
                    items: _roles
                        .map((role) => DropdownMenuItem(
                              value: role,
                              child: Text(role),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value;
                      });
                    },
                    validator: (value) => value == null || value.isEmpty
                        ? 'Selecciona un rol'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Contraseña',
                    style: TextStyle(
                      fontFamily: appFontFamily,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: autoGray900,
                    ),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: autoGray200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Contraseña',
                    ),
                    obscureText: !_showPassword,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Campo requerido'
                        : null,
                  ),
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
                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : registerUser,
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
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Registrarse',
                              style: TextStyle(
                                fontFamily: appFontFamily,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '¿Ya tienes una cuenta?',
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
                              AppRoutes.login,
                            );
                          },
                          child: Text(
                            'Inicia sesión',
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
