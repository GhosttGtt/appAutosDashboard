import 'package:autozone/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:autozone/theme/fonts.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.white,
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Container(
             width: MediaQuery.of(context).size.width - 75,
             alignment: Alignment.center,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: TitleText(
                        text: 'Iniciar sesión',
                      ),
                    ),
                    SizedBox(height: 20,),
                    Text(
                      'Usuario',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontFamily: appFontFamily,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: autoGray900,
                      ),
                    ),
                    TextField(
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
                    SizedBox(height: 20,),
                    Text(
                      'Contraseña',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontFamily: appFontFamily,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: autoGray900,
                      ),
                    ),
                    TextField(
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
                    SizedBox(height: 20,),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
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
                        child: Text(
                          'Ingresar',
                          style: TextStyle(
                            fontFamily: appFontFamily,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
            ),
          ),
        ),
        ),
      );
  }
}

