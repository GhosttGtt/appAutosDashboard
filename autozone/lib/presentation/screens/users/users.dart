import 'package:flutter/material.dart';
import 'package:autozone/core/services/api_global.dart';
import 'package:autozone/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<UserModel> users = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    userData();
  }

  Future<void> userData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final response = await http.get(
      Uri.parse('${Api.apiUrl}${Api.users}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    await SharedPreferences.getInstance();

    setState(() {
      users = [];
      loading = true;
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List rawUsers = jsonData['data'] ?? [];
      users = rawUsers.map((json) => UserModel.fromJson(json)).toList();

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
          title: const Text('Usuarios'),
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) => Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: users[index].photo.isNotEmpty
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(users[index].photo),
                        )
                      : const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(users[index].name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ID: ${users[index].id}',
                          style: const TextStyle(fontSize: 14)),
                      Text('Email: ${users[index].email}',
                          style: const TextStyle(fontSize: 14)),
                      Text('Rol: ${users[index].role}',
                          style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
