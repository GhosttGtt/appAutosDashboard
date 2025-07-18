// ignore_for_file: use_build_context_synchronously, sort_child_properties_last, avoid_print

import 'dart:async';
import 'package:autozone/core/services/api_global.dart';
import 'package:autozone/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditUserScreen extends StatefulWidget {
  const EditUserScreen({super.key});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _nameController.text = prefs.getString('name') ?? '';
    _emailController.text = prefs.getString('email') ?? '';
    _usernameController.text = prefs.getString('username') ?? '';
    _roleController.text = prefs.getString('role') ?? '';
  }

  void _saveUserData() async {
    print("v");
    final url = Uri.parse('${Api.apiUrl}${Api.userEdit}');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final userId = prefs.getString('userId') ?? '';

    await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text);
    await prefs.setString('email', _emailController.text);
    await prefs.setString('username', _usernameController.text);
    await prefs.setString('role', _roleController.text);

    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _roleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'id': userId,
          'name': _nameController.text,
          'email': _emailController.text,
          'username': _usernameController.text,
          'role': _roleController.text,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Datos actualizados exitosamente')),
        );
        Navigator.pushReplacementNamed(context, AppRoutes.user);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(data['message'] ?? 'Error al actualizar datos')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error de c')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Usuario'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: _nameController.text),
            ),
            TextField(
              controller: _emailController,
              decoration:
                  const InputDecoration(labelText: 'Correo Electrónico'),
            ),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Nombre de Usuario'),
            ),
            TextField(
              controller: _roleController,
              decoration: const InputDecoration(labelText: 'Rol'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveUserData,
              child: const Text('Guardar Cambios'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
