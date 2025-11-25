import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF5A94E0);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFF5A94E0)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Colors.black;

const kAnimationDuration = Duration(milliseconds: 200);

const headingStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

const String kEmailNullError = "Por favor ingrese su correo electrónico";
const String kInvalidEmailError = "Por favor ingrese un correo electrónico válido";
const String kUserNameNullError = "Por favor ingrese su nombre de usuario";
const String kPassNullError = "Por favor ingrese su contraseña";
const String kShortPassError = "La contraseña es muy corta";
const String kMatchPassError = "Las contraseñas no coinciden";
const String kNamelNullError = "Por favor ingrese su nombre";
const String kPhoneNumberNullError = "Por favor ingrese su número de teléfono";
const String kAddressNullError = "Por favor ingrese su dirección";

// Nuevos errores para CompleteProfileForm
const String kCarnetNullError = "Por favor ingrese su carnet";
const String kLugarTrabajoNullError = "Por favor ingrese su lugar de trabajo";
const String kTipoTrabajoNullError = "Por favor ingrese el tipo de trabajo";
const String kIngresoMensualNullError = "Por favor ingrese su ingreso mensual";

final otpInputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(vertical: 16),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: const BorderSide(color: kTextColor),
  );
}
