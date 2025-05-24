import 'package:flutter/material.dart';
import 'package:autozone/presentation/theme/colors.dart';
import 'package:autozone/presentation/theme/fonts.dart';
import 'package:autozone/presentation/screens/forgot_password/forgot_password_screen.dart';
import 'package:autozone/core/controllers/auth_controller.dart';
import 'package:autozone/presentation/screens/register/register_screen.dart';
import 'package:autozone/presentation/screens/home/home_screen.dart';

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
  setState(() => _isLoading = true);

  try {
    final result = await AuthController.loginUser(
      _usernameController.text,
      _passwordController.text,
    );

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(username: result['username'] ?? ''),
      ),
    );
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: completar todos los campos')),
    );
  } finally {
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Use a valid color instead of undefined autoGray100.
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width - 75,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/logoGris.png',
                  width: 200,
                  height: 75,
                ),
              ), // Logo de la aplicación
              const SizedBox(height: 20),
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
              ), // Título del inicio de sesión
              const SizedBox(height: 20),
              Text(
                'Usuario',
                style: TextStyle(
                  fontFamily: appFontFamily,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: autoGray900,
                ),
              ), // Etiqueta de usuario
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
              ), // Campo de texto para el usuario
              const SizedBox(height: 20),
              Text(
                'Contraseña',
                style: TextStyle(
                  fontFamily: appFontFamily,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: autoGray900,
                ),
              ), // Etiqueta de contraseña
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
              ), // Campo de texto para la contraseña
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
              ), // Opción para mostrar la contraseña
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
                      vertical: 12,
                      horizontal: 20,
                    ),
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
              ), // Botón de inicio de sesión
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ForgotPasswordScreen(),
                    ),
                  );
                },
                child: Text(
                  '¿Olvidaste tu contraseña?',
                  style: TextStyle(
                    fontFamily: appFontFamily,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: autoGray900,
                    decoration: TextDecoration.underline,
                    height: 3.5,
                  ),
                ),
              ), // Enlace para recuperar contraseña
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RegisterScreen(),
                    ),
                  );
                },
                child: Text(
                  '¿No tienes una cuenta? Regístrate aquí',
                  style: TextStyle(
                    color: autoGray900,
                    fontFamily: appFontFamily,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.underline,
                    height: 1.5,
                  ),
                ),
              ),// Enlace para registrarse
            ],
          ),
        ),
      ),
    );
  }
}
 
