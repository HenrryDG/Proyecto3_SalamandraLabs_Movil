import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../components/no_account_text.dart';
import 'components/sign_form.dart';

class SignInScreen extends StatelessWidget {
  static String routeName = "/sign_in";

  const SignInScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // Mostrar diálogo de confirmación para salir de la app
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("¿Salir de la aplicación?"),
              content: const Text("¿Estás seguro de que deseas salir?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancelar"),
                ),
                TextButton(
                  onPressed: () => SystemNavigator.pop(),
                  child: const Text("Salir"),
                ),
              ],
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Iniciar Sesión"),
          automaticallyImplyLeading: false, // No mostrar botón de atrás
        ),
        body: const SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    Text(
                      "Bienvenido!",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Inicie sesión con su correo electrónico y contraseña",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    SignForm(),
                    SizedBox(height: 20),
                    NoAccountText(),
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
