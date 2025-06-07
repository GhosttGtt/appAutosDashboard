import 'package:flutter/material.dart';
import 'package:autozone/core/services/api_global.dart';
import 'package:autozone/data/models/client_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:autozone/routes/routes.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  List<ClientModel> clients = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    clientData();
  }

  Future<void> clientData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final response = await http.get(
      Uri.parse('${Api.apiUrl}${Api.clients}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    await SharedPreferences.getInstance();

    setState(() {
      clients = [];
      loading = true;
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List rawClients = jsonData['data'] ?? [];
      clients = rawClients.map((json) => ClientModel.fromJson(json)).toList();

      setState(() {
        loading = false;
      });
    } else {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            color: Colors.white,
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.home);
            },
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: clients.length,
              itemBuilder: (context, index) => Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 40,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/client.png',
                        fit: BoxFit.cover,
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ),
                  title: Text(clients[index].name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ID: ${clients[index].id}',
                          style: const TextStyle(fontSize: 14)),
                      Text('Nombre: ${clients[index].name}',
                          style: const TextStyle(fontSize: 14)),
                      Text('Apellido: ${clients[index].lastname}',
                          style: const TextStyle(fontSize: 14)),
                      Text('Email: ${clients[index].email}',
                          style: const TextStyle(fontSize: 14)),
                      Text('Teléfono: ${clients[index].phone}',
                          style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit_note_outlined,
                        color: Colors.black),
                    onPressed: () async {
                      await Navigator.pushNamed(
                        context,
                        AppRoutes.editClients,
                        arguments: clients[index].id,
                      );
                      clientData();
                    },
                  ),
                ),
              ),
            ),
    );
  }
}
