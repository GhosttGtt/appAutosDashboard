import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:autozone/core/services/api_global.dart';
import 'package:http_parser/http_parser.dart'; // Para MediaType

class EditUserPhotoScreen extends StatefulWidget {
  final int userId;
  const EditUserPhotoScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<EditUserPhotoScreen> createState() => _EditUserPhotoScreenState();
}

class _EditUserPhotoScreenState extends State<EditUserPhotoScreen> {
  File? photo;
  bool _loading = false;
  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        photo = File(pickedFile.path);
      });
    }
  }

  Future<bool> uploadUserPhoto(int userId, File imageFile) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final uri = Uri.parse('${Api.apiUrl}${Api.userPhotoUpdate}');

    final request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer $token';

    request.fields['id'] = userId.toString();

    request.files.add(
      await http.MultipartFile.fromPath(
        'photo',
        imageFile.path,
        contentType: MediaType('image', 'png'),
      ),
    );

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Error subida foto: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception al subir foto: $e');
      return false;
    }
  }

  Future uploadPhoto() async {
    if (photo == null) return;

    setState(() {
      _loading = true;
    });

    final success = await uploadUserPhoto(widget.userId, photo!);

    setState(() {
      _loading = false;
    });

    if (success) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al subir la foto')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Actualizar Foto')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            photo == null
                ? const Icon(Icons.person, size: 100)
                : Image.file(photo!, height: 150),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickImage,
              child: const Text('Seleccionar imagen'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : uploadPhoto,
              child: _loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Subir foto'),
            ),
          ],
        ),
      ),
    );
  }
}
