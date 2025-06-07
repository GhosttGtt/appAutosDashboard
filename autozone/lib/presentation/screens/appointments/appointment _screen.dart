// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:autozone/core/services/api_global.dart';

class Appointment {
  final String clientName;
  final DateTime date;
  final String clientEmail;
  final String personas;

  Appointment({
    required this.clientName,
    required this.date,
    required this.clientEmail,
    required this.personas,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      clientName: json['name'] ?? '',
      clientEmail: json['email'] ?? '',
      date: DateTime.parse(json['date']),
      personas: json['personas'] ?? '',
    );
  }
}

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  List<Appointment> allAppointments = [];
  bool loading = true;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    setState(() => loading = true);
    try {
      final response =
          await http.get(Uri.parse('${Api.apiUrl}${Api.appointments}'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        setState(() {
          allAppointments = data.map((e) => Appointment.fromJson(e)).toList();
          loading = false;
        });
      } else {
        setState(() => loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al cargar las citas')),
        );
      }
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error de conexión')),
      );
    }
  }

  List<Appointment> get filteredAppointments {
    if (selectedDate == null) return allAppointments;
    return allAppointments
        .where((a) =>
            a.date.year == selectedDate!.year &&
            a.date.month == selectedDate!.month &&
            a.date.day == selectedDate!.day)
        .toList();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Citas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: _pickDate,
            tooltip: 'Filtrar por fecha',
          ),
          if (selectedDate != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => setState(() => selectedDate = null),
              tooltip: 'Quitar filtro',
            ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : filteredAppointments.isEmpty
              ? const Center(child: Text('No hay citas para esta fecha'))
              : ListView.builder(
                  itemCount: filteredAppointments.length,
                  itemBuilder: (context, index) {
                    final appointment = filteredAppointments[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: const Icon(Icons.event_note),
                        title: Text(appointment.clientName),
                        subtitle: Text(
                          '${DateFormat('dd/MM/yyyy').format(appointment.date)}\n${appointment.clientEmail}\n${appointment.personas}',
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
