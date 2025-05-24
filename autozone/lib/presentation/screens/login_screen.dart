import 'package:flutter/material.dart';
import 'package:autozone/presentation/theme/colors.dart';
import 'package:autozone/presentation/theme/fonts.dart';
import 'package:autozone/core/services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false;
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final success = await ApiService.loginUser(
      _usernameController.text.trim(),
      _passwordController.text.trim(),
    );

    setState(() {
      _isLoading = false;
    });

    if (success) {
      // Si el login fue exitoso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inicio de sesión exitoso')),
      );
      // Aquí podrías navegar a otra pantalla
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario o contraseña incorrectos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width - 75,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Iniciar sesión',
                    style: TextStyle(
                      fontFamily: appFontFamily,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: autoGray900,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Usuario',
                  style: TextStyle(
                    fontFamily: appFontFamily,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: autoGray900,
                  ),
                ),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: autoGray200,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Nombre de usuario',
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Contraseña',
                  style: TextStyle(
                    fontFamily: appFontFamily,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: autoGray900,
                  ),
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: !_showPassword,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: autoGray200,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Ingresar contraseña',
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _showPassword,
                      onChanged: (value) {
                        setState(() {
                          _showPassword = value!;
                        });
                      },
                    ),
                    Text(
                      'Mostrar contraseña',
                      style: TextStyle(
                        fontFamily: appFontFamily,
                        fontSize: 16,
                        color: autoGray900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  '¿Olvidaste tu contraseña?',
                  style: TextStyle(
                    fontFamily: appFontFamily,
                    fontSize: 16,
                    color: autoGray900,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: autoPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Ingresar',
                            style: TextStyle(
                              fontFamily: appFontFamily,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
