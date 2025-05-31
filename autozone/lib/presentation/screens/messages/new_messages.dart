import 'package:flutter/material.dart';
import 'package:autozone/core/services/api_global.dart';
import 'package:autozone/data/models/messages_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class NewMessagesScreen extends StatefulWidget {
  const NewMessagesScreen({super.key});

  @override
  State<NewMessagesScreen> createState() => _NewMessagesScreenState();
}

class _NewMessagesScreenState extends State<NewMessagesScreen> {
  List<MessagesModel> messages = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    messagesData();
  }

  Future<void> messagesData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final response = await http.get(
      Uri.parse('${Api.apiUrl}${Api.messages}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    await SharedPreferences.getInstance();

    setState(() {
      messages = [];
      loading = true;
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List rawMessages = jsonData['data'] ?? [];
      messages =
          rawMessages.map((json) => MessagesModel.fromJson(json)).toList();

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
          title: const Text('Mensajes'),
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) => Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(messages[index].name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ID: ${messages[index].id}',
                          style: const TextStyle(fontSize: 14)),
                      Text('Nombre: ${messages[index].name}',
                          style: const TextStyle(fontSize: 14)),
                      Text('Teléfono: ${messages[index].phone}',
                          style: const TextStyle(fontSize: 14)),
                      Text('Email: ${messages[index].email}',
                          style: const TextStyle(fontSize: 14)),
                      Text('Asunto: ${messages[index].subject}',
                          style: const TextStyle(fontSize: 14)),
                      Text('Mensaje: ${messages[index].message}',
                          style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
