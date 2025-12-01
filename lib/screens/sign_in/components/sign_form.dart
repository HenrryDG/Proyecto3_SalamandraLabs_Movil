import 'package:flutter/material.dart';

import '../../../components/custom_surfix_icon.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';
import '../../../helper/keyboard.dart';
import '../../login_success/login_success_screen.dart';
import '../../../services/api_service.dart';

class SignForm extends StatefulWidget {
  const SignForm({super.key});

  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String? username;
  String? password;
  bool? remember = false;
  bool isLoading = false;

  final List<String?> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.text,
            onSaved: (newValue) => username = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kUserNameNullError);
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kUserNameNullError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Usuario",
              hintText: "Ingrese su usuario",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Email.svg"),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            obscureText: true,
            onSaved: (newValue) => password = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kPassNullError);
              } else if (value.length >= 8) {
                removeError(error: kShortPassError);
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kPassNullError);
                return "";
              }

              return null;
            },
            decoration: const InputDecoration(
              labelText: "Contraseña",
              hintText: "Ingrese su contraseña",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
            ),
          ),
          const SizedBox(height: 20),
          FormError(errors: errors),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: isLoading
                ? null
                : () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      KeyboardUtil.hideKeyboard(context);

                      setState(() => isLoading = true);

                      final api = ApiService();
                      bool success = await api.login(
                        username: username!,
                        password: password!,
                      );

                      setState(() => isLoading = false);

                      if (success) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          LoginSuccessScreen.routeName,
                          (route) => false,
                        );
                      } else {
                        addError(error: "Usuario o contraseña incorrectos");
                      }
                    }
                  },
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("Ingresar"),
          ),
        ],
      ),
    );
  }
}
