import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart';
import 'package:autozone/core/services/api_global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddVehicule extends StatefulWidget {
  final VoidCallback? onCarAdded;

  const AddVehicule({Key? key, this.onCarAdded}) : super(key: key);

  @override
  State<AddVehicule> createState() => _AddVehiculeState();
}

class _AddVehiculeState extends State<AddVehicule> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _motorController = TextEditingController();
  final TextEditingController _fuelController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _typeIdController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  File? _imageFile;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage(File image) async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una imagen primero')),
      );
      return;
    }

    if (!await _imageFile!.exists() || await _imageFile!.length() == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('El archivo de imagen no existe o está vacío.')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    // Usa el endpoint correcto para subir la foto
    final url = Uri.parse('https://alexcg.de/autozone/api/cars_edit_photo.php');
    //print('Uploading photo to: $url');

    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';

    final fileName = _imageFile!.path.split(Platform.pathSeparator).last;
    request.files.add(
      await http.MultipartFile.fromPath(
        'photo',
        _imageFile!.path,
        filename: fileName,
        // No pongas contentType, deja que lo detecte automáticamente
      ),
    );

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      //print('Response status: ${response.statusCode}');
      //print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Foto actualizada exitosamente')),
          );
        }
        await _submit();
        setState(() {
          _imageFile = null;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error del servidor: ${response.body}')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al subir la foto: $e')),
        );
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    String imageName = 'default.jpg';
    if (_imageFile != null) {
      try {
        await _uploadImage(_imageFile!);
        // If you want to set imageName to the uploaded file's name, you need to get it from _imageFile or the server response.
        imageName = _imageFile!.path.split(Platform.pathSeparator).last;
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al subir la imagen')),
        );
        return;
      }
    }

    final Map<String, dynamic> carData = {
      "brand": _brandController.text,
      "description": _descriptionController.text,
      "motor": _motorController.text,
      "fuel": _fuelController.text,
      "model": _modelController.text,
      "year": int.tryParse(_yearController.text) ?? 0,
      "price": int.tryParse(_priceController.text) ?? 0,
      "image": imageName,
      "stock": int.tryParse(_stockController.text) ?? 0,
    };

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final response = await http.post(
        Uri.parse('${Api.apiUrl}${Api.create_car}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(carData),
      );

      if (response.statusCode == 200) {
        if (widget.onCarAdded != null) widget.onCarAdded!();
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al agregar el auto')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error de conexión')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Agregar Nuevo Auto'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!)
                      : const AssetImage('assets/default.jpg') as ImageProvider,
                  child: _imageFile == null
                      ? const Icon(Icons.camera_alt,
                          size: 32, color: Colors.white70)
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _brandController,
                decoration: const InputDecoration(labelText: 'Marca'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _motorController,
                decoration: const InputDecoration(labelText: 'Motor'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _fuelController,
                decoration: const InputDecoration(labelText: 'Combustible'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _modelController,
                decoration: const InputDecoration(labelText: 'Modelo'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _yearController,
                decoration: const InputDecoration(labelText: 'Año'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Agregar'),
        ),
      ],
    );
  }
}
