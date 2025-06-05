// ignore_for_file: avoid_print

import 'package:autozone/presentation/theme/colors.dart';
import 'package:autozone/presentation/widgets/custom_drawer.dart';
import 'package:autozone/presentation/widgets/menu.dart';
import 'package:autozone/routes/routes.dart';
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
      endDrawer: const CustomDrawer(),
      backgroundColor: autoGray200,
      body: Column(children: [
        Menu(),
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: autoPrimaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_outlined),
                      iconSize: 20,
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, AppRoutes.home);
                        /* messagesData(); */
                      },
                    ),
                  ),
                  const Text(
                    'Mensajes',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  )
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 200,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          print('Message tapped: ${messages[index].id}');
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: autoPrimaryColor.withValues(
                                    alpha: 0.05,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                      Icons.messenger_outline_sharp,
                                      color: autoPrimaryColor,
                                      size: 22),
                                  onPressed: () {},
                                ),
                              ),
                              const SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 115,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          child: Text(
                                            messages[index].name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        if (messages[index].status.toString() ==
                                            '0')
                                          Container(
                                            width: 15,
                                            height: 15,
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Text(messages[index].subject,
                                      style: const TextStyle(fontSize: 14)),
                                ],
                              ),

                              /*  ListTile(
                                  title: Text(messages[index].name),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.phone, size: 16),
                                          const SizedBox(width: 8),
                                          Text(messages[index].phone,
                                              style:
                                                  const TextStyle(fontSize: 14)),
                                        ],
                                      ),
                                      /* Text('ID: ${messages[index].id}',
                                        style: const TextStyle(fontSize: 14)), */
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
                                ), */
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ]),
    );
  }
}
