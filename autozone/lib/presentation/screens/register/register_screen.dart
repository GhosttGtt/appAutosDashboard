// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' ;
import 'package:mime/mime.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  File? _image;

  Future pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> registerUser() async {
    var uri = Uri.parse('https://alexcg.de/autozone/api/user_create.php');
    var request = http.MultipartRequest('POST', uri);

    request.fields['name'] = _nameController.text;
    request.fields['username'] = _usernameController.text;
    request.fields['email'] = _emailController.text;
    request.fields['password'] = _passwordController.text;

    if (_image != null) {
      final mimeType = lookupMimeType(_image!.path)!.split('/');
      request.files.add(await http.MultipartFile.fromPath(
        'photo',
        _image!.path,
        contentType: MediaType(mimeType[0], mimeType[1]),
      ));
    }
    var response = await request.send();
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario registrado con éxito')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar usuario')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Crear Usuario")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: InputDecoration(labelText: 'Nombre')),
            TextField(controller: _usernameController, decoration: InputDecoration(labelText: 'Usuario')),
            TextField(controller: _emailController, decoration: InputDecoration(labelText: 'Correo')),
            TextField(controller: _passwordController, decoration: InputDecoration(labelText: 'Contraseña'), obscureText: true),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: pickImage,
              child: Text('Seleccionar Foto'),
            ),
            if (_image != null)
              Image.file(_image!, height: 100),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: registerUser,
              child: Text('Crear cuenta'),
            ),
          ],
        ),
      ),
    );
  }
}
