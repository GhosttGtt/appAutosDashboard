// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'dart:async';
import 'dart:io';

import 'package:autozone/core/services/api_global.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:autozone/data/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:image_picker/image_picker.dart';

class EditAllUserScreen extends StatefulWidget {
  final int id;

  const EditAllUserScreen({super.key, required this.id});

  @override
  State<EditAllUserScreen> createState() => _EditAllUserScreenState();
}

class _EditAllUserScreenState extends State<EditAllUserScreen> {
  final TextEditingController _allUserFullName = TextEditingController();
  final TextEditingController _allUseremail = TextEditingController();
  final TextEditingController _allUsername = TextEditingController();
  final TextEditingController _allUserrol = TextEditingController();

  UserModel? user;
  bool loading = true;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final response = await http.post(
      Uri.parse('${Api.apiUrl}${Api.users}/${widget.id}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List<dynamic> rawUsers = jsonData['data'] ?? [];

      final matchingUser = rawUsers.firstWhere(
        (u) => u['id'] == widget.id,
        orElse: () => null,
      );

      if (matchingUser == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usuario no encontrado')),
          );
        }
        return;
      }

      setState(() {
        user = UserModel.fromJson(matchingUser);
        _allUserFullName.text = user!.name;
        _allUseremail.text = user!.email;
        _allUsername.text = user!.username;
        _allUserrol.text = user!.role;
        loading = false;
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('No se pudo cargar la información del usuario')),
        );
      }
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _saveUserData() async {
    final url = Uri.parse('${Api.apiUrl}${Api.userEdit}');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (_allUserFullName.text.isEmpty ||
        _allUseremail.text.isEmpty ||
        _allUsername.text.isEmpty ||
        _allUserrol.text.isEmpty) {
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
          'id': widget.id,
          'name': _allUserFullName.text,
          'email': _allUseremail.text,
          'username': _allUsername.text,
          'role': _allUserrol.text,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 &&
          (data['success'] == true || data['ok'] == true)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Datos actualizados exitosamente')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(data['message'] ?? 'Error al actualizar datos')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error de conexión')),
      );
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadUserPhoto() async {
    if (_selectedImage == null) return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url = Uri.parse('${Api.apiUrl}${Api.users}/${widget.id}/photo');

    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';
    request.files
        .add(await http.MultipartFile.fromPath('photo', _selectedImage!.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto actualizada exitosamente')),
        );
      }
      await _loadUserData();
      setState(() {
        _selectedImage = null;
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al actualizar la foto')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Usuario'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: _selectedImage != null
                  ? FileImage(_selectedImage!)
                  : (user != null && user!.photo.isNotEmpty
                      ? NetworkImage(user!.photo)
                      : null) as ImageProvider<Object>?,
              child: (user == null || user!.photo.isEmpty) &&
                      _selectedImage == null
                  ? const Icon(Icons.person, size: 60)
                  : null,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.photo_library),
              label: const Text('Seleccionar nueva foto'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
            ),
            if (_selectedImage != null)
              ElevatedButton.icon(
                onPressed: _uploadUserPhoto,
                icon: const Icon(Icons.upload),
                label: const Text('Subir foto'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            const SizedBox(height: 20),
            TextField(
              controller: _allUserFullName,
              decoration: const InputDecoration(labelText: 'Nombre completo'),
            ),
            TextField(
              controller: _allUseremail,
              decoration:
                  const InputDecoration(labelText: 'Correo Electrónico'),
            ),
            TextField(
              controller: _allUsername,
              decoration: const InputDecoration(labelText: 'Nombre de Usuario'),
            ),
            TextField(
              controller: _allUserrol,
              decoration: const InputDecoration(labelText: 'Rol'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveUserData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
              child: const Text('Guardar Cambios'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
