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

  Future<void> _showMessageDialog(MessagesModel message) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                margin: EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: autoPrimaryColor.withValues(
                    alpha: 0.05,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: IconButton(
                  icon: const Icon(Icons.messenger_outline_sharp,
                      color: autoPrimaryColor, size: 22),
                  onPressed: () {},
                ),
              ),
              Text(
                message.subject,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                width: MediaQuery.of(context).size.width - 115,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nombre: ${message.name}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Email ${message.email}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Teléfono: ${message.phone}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: autoGray200,
                          borderRadius: BorderRadius.circular(
                            12,
                          )),
                      child: Text(message.message,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          )),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: autoPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: const Text(
                      'Aceptar',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateMessageStatus(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final response = await http.post(
      Uri.parse('${Api.apiUrl}${Api.messageUpdate}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'id': id, 'status': 1}),
    );

    if (response.statusCode == 200) {
      setState(() {
        messages = messages
            .map((m) => m.id == id
                ? MessagesModel(
                    id: m.id,
                    name: m.name,
                    phone: m.phone,
                    email: m.email,
                    subject: m.subject,
                    message: m.message,
                    status: 1,
                  )
                : m)
            .toList();
      });
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
                        onTap: () async {
                          await _showMessageDialog(messages[index]);
                          if (messages[index].status == 0) {
                            await _updateMessageStatus(messages[index].id);
                          }
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
