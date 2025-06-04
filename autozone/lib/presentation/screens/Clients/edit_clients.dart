// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:autozone/core/services/api_global.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:autozone/data/models/client_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditClientsScreen extends StatefulWidget {
  final int id;

  const EditClientsScreen({super.key, required this.id});

  @override
  State<EditClientsScreen> createState() => _EditClientsScreenState();
}

class _EditClientsScreenState extends State<EditClientsScreen> {
  final TextEditingController _clientname = TextEditingController();
  final TextEditingController _clientlastname = TextEditingController();
  final TextEditingController _clientemail = TextEditingController();
  final TextEditingController _clientphone = TextEditingController();

  ClientModel? client;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadClientData();
  }

  Future<void> _loadClientData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final response = await http.get(
      Uri.parse('${Api.apiUrl}${Api.clients}/${widget.id}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List<dynamic> rawClients = jsonData['data'] ?? [];

      final matchingClient = rawClients.firstWhere(
        (u) => u['id'] == widget.id,
        orElse: () => null,
      );

      if (matchingClient == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cliente no encontrado')),
          );
        }
        return;
      }

      setState(() {
        client = ClientModel.fromJson(matchingClient);
        _clientname.text = client!.name;
        _clientlastname.text = client!.lastname;
        _clientemail.text = client!.email;
        _clientphone.text = client!.phone;
        loading = false;
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('No se pudo cargar la información del cliente')),
        );
      }
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _saveClientData() async {
    final url = Uri.parse('${Api.apiUrl}${Api.clientEdit}');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (_clientname.text.isEmpty ||
        _clientlastname.text.isEmpty ||
        _clientemail.text.isEmpty ||
        _clientphone.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'id': widget.id,
          'name': _clientname.text,
          'lastname': _clientlastname.text,
          'email': _clientemail.text,
          'phone': _clientphone.text,
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

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Cliente'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _clientname,
              decoration: const InputDecoration(labelText: 'Nombre completo'),
            ),
            TextField(
              controller: _clientlastname,
              decoration: const InputDecoration(labelText: 'Apellido'),
            ),
            TextField(
              controller: _clientemail,
              decoration:
                  const InputDecoration(labelText: 'Correo Electrónico'),
            ),
            TextField(
              controller: _clientphone,
              decoration: const InputDecoration(labelText: 'Teléfono'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _saveClientData();
              },
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
