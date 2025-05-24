import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _tempPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  bool showUpdateFields = false;

  void sendRecoveryEmail() async {
    // Simular llamada API para enviar email con contraseña temporal
    setState(() {
      showUpdateFields = true;
    });
  }

  void updatePassword() async {
    // Aqui debo llamar a la API para actualizar la contraseña
    // con los campos: usuario, contraseña temporal, nueva contraseña
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Contraseña actualizada con éxito')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recuperar contraseña")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Usuario'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Correo electrónico'),
            ),
            ElevatedButton(
              onPressed: sendRecoveryEmail,
              child: Text('Enviar contraseña temporal'),
            ),
            if (showUpdateFields) ...[
              TextField(
                controller: _tempPasswordController,
                decoration: InputDecoration(labelText: 'Contraseña temporal'),
              ),
              TextField(
                controller: _newPasswordController,
                decoration: InputDecoration(labelText: 'Nueva contraseña'),
              ),
              ElevatedButton(
                onPressed: updatePassword,
                child: Text('Actualizar contraseña'),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
