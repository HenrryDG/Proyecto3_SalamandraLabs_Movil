import 'package:flutter/material.dart';
import '../../../components/custom_surfix_icon.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';
import '../../../models/temp_cliente.dart';
import '../../../models/cliente.dart';
import '../../../services/api_service.dart';

class CompleteProfileForm extends StatefulWidget {
  final TempCliente tempCliente;

  const CompleteProfileForm({super.key, required this.tempCliente});

  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  final _formKey = GlobalKey<FormState>();
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
          // Carnet
          TextFormField(
            onSaved: (newValue) => widget.tempCliente.carnet = newValue!,
            validator: (value) {
              if (value == null || value.isEmpty) {
                addError(error: kNamelNullError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Carnet",
              hintText: "Ingresa tu carnet",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
            ),
          ),
          const SizedBox(height: 20),

          // Complemento (opcional)
          TextFormField(
            onSaved: (newValue) => widget.tempCliente.complemento = newValue,
            decoration: const InputDecoration(
              labelText: "Complemento",
              hintText: "Ingresa complemento (opcional)",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
            ),
          ),
          const SizedBox(height: 20),

          // Nombre
          TextFormField(
            onSaved: (newValue) => widget.tempCliente.nombre = newValue!,
            validator: (value) {
              if (value == null || value.isEmpty) {
                addError(error: kNamelNullError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Nombre",
              hintText: "Ingresa tu nombre",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
            ),
          ),
          const SizedBox(height: 20),

          // Apellido Paterno
          TextFormField(
            onSaved: (newValue) =>
                widget.tempCliente.apellidoPaterno = newValue,
            decoration: const InputDecoration(
              labelText: "Apellido Paterno",
              hintText: "Ingresa tu apellido paterno",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
            ),
          ),
          const SizedBox(height: 20),

          // Apellido Materno
          TextFormField(
            onSaved: (newValue) =>
                widget.tempCliente.apellidoMaterno = newValue,
            decoration: const InputDecoration(
              labelText: "Apellido Materno",
              hintText: "Ingresa tu apellido materno",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
            ),
          ),
          const SizedBox(height: 20),

          // Lugar de trabajo
          TextFormField(
            onSaved: (newValue) => widget.tempCliente.lugarTrabajo = newValue!,
            validator: (value) {
              if (value == null || value.isEmpty) {
                addError(error: kNamelNullError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Lugar de trabajo",
              hintText: "Ingresa tu lugar de trabajo",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Work.svg"),
            ),
          ),
          const SizedBox(height: 20),

          // Tipo de trabajo
          TextFormField(
            onSaved: (newValue) => widget.tempCliente.tipoTrabajo = newValue!,
            validator: (value) {
              if (value == null || value.isEmpty) {
                addError(error: kNamelNullError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Tipo de trabajo",
              hintText: "Ingresa tipo de trabajo",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Work.svg"),
            ),
          ),
          const SizedBox(height: 20),

          // Ingreso mensual
          TextFormField(
            keyboardType: TextInputType.number,
            onSaved: (newValue) => widget.tempCliente.ingresoMensual =
                double.tryParse(newValue ?? '0') ?? 0,
            validator: (value) {
              if (value == null || value.isEmpty) {
                addError(error: kNamelNullError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Ingreso Mensual",
              hintText: "Ingresa tu ingreso mensual",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Money.svg"),
            ),
          ),
          const SizedBox(height: 20),

          // Dirección
          TextFormField(
            onSaved: (newValue) => widget.tempCliente.direccion = newValue!,
            validator: (value) {
              if (value == null || value.isEmpty) {
                addError(error: kAddressNullError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Dirección",
              hintText: "Ingresa tu dirección",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon:
                  CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
            ),
          ),
          const SizedBox(height: 20),

          // Correo (opcional)
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            onSaved: (newValue) => widget.tempCliente.correo = newValue,
            decoration: const InputDecoration(
              labelText: "Correo",
              hintText: "Ingresa tu correo (opcional)",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
            ),
          ),
          const SizedBox(height: 20),

          // Teléfono
          TextFormField(
            keyboardType: TextInputType.phone,
            onSaved: (newValue) => widget.tempCliente.telefono =
                int.tryParse(newValue ?? '0') ?? 0,
            validator: (value) {
              if (value == null || value.isEmpty) {
                addError(error: kPhoneNumberNullError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Número de Teléfono",
              hintText: "Ingresa tu número de teléfono",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
            ),
          ),
          const SizedBox(height: 20),

          FormError(errors: errors),
          const SizedBox(height: 20),

          // Botón Registrar
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                try {
                  await ApiService().registrarCliente(
                    cliente: Cliente(
                      carnet: widget.tempCliente.carnet!,
                      complemento: widget.tempCliente.complemento,
                      nombre: widget.tempCliente.nombre!,
                      apellidoPaterno: widget.tempCliente.apellidoPaterno,
                      apellidoMaterno: widget.tempCliente.apellidoMaterno,
                      lugarTrabajo: widget.tempCliente.lugarTrabajo!,
                      tipoTrabajo: widget.tempCliente.tipoTrabajo!,
                      ingresoMensual: widget.tempCliente.ingresoMensual!,
                      direccion: widget.tempCliente.direccion!,
                      correo: widget.tempCliente.correo,
                      telefono: widget.tempCliente.telefono!,
                    ),
                    username: widget.tempCliente.username!,
                    password: widget.tempCliente.password!,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Cliente registrado con éxito')),
                  );

                  // Aquí puedes navegar al login o home si quieres
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al registrar: $e')),
                  );
                }
              }
            },
            child: const Text("Registrarse"),
          ),
        ],
      ),
    );
  }
}
