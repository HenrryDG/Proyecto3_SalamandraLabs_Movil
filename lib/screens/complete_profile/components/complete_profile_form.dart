import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool isLoading = false;

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() => errors.add(error));
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() => errors.remove(error));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // =============================
          // CARNET
          // =============================
          TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(
                (widget.tempCliente.complemento == null ||
                        widget.tempCliente.complemento!.isEmpty)
                    ? 8
                    : 7,
              ),
            ],
            onSaved: (newValue) => widget.tempCliente.carnet = newValue!,
            onChanged: (value) {
              if (value.isNotEmpty) removeError(error: kCarnetNullError);
              setState(
                  () {}); // Para actualizar límite cuando cambia complemento
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                addError(error: kCarnetNullError);
                return "";
              }

              final noComplemento = widget.tempCliente.complemento == null ||
                  widget.tempCliente.complemento!.isEmpty;

              const minLength = 5;
              final maxLength = noComplemento ? 8 : 7;

              if (value.length < minLength || value.length > maxLength) {
                return "Debe tener entre $minLength y $maxLength dígitos";
              }

              return null;
            },
            decoration: const InputDecoration(
              labelText: "Carnet",
              hintText: "Ingresa tu carnet",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Carnet.svg"),
            ),
          ),
          const SizedBox(height: 20),

          // =============================
          // COMPLEMENTO
          // =============================
          TextFormField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^[0-9a-zA-Z]*$')),
              LengthLimitingTextInputFormatter(2),
            ],
            onChanged: (value) {
              setState(() {});
            },
            onSaved: (newValue) => widget.tempCliente.complemento = newValue,
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                if (value.length != 2) {
                  return "Debe tener exactamente 2 caracteres";
                }
                if (!RegExp(r'^[0-9][A-Za-z]$').hasMatch(value)) {
                  return "Formato inválido (Ej: 1A)";
                }
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Complemento",
              hintText: "Ej: 1A (opcional)",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Carnet.svg"),
            ),
          ),
          const SizedBox(height: 20),

          // =============================
          // NOMBRE
          // =============================
          TextFormField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r"[a-zA-ZáéíóúÁÉÍÓÚñÑ ]")),
            ],
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

          // =============================
          // APELLIDO PATERNO
          // =============================
          TextFormField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r"[a-zA-ZáéíóúÁÉÍÓÚñÑ ]")),
            ],
            onSaved: (newValue) =>
                widget.tempCliente.apellidoPaterno = newValue,
            validator: (value) {
              final apM = widget.tempCliente.apellidoMaterno;
              if ((value == null || value.isEmpty) &&
                  (apM == null || apM.isEmpty)) {
                return "Debe ingresar al menos un apellido";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Apellido Paterno",
              hintText: "Ingresa tu apellido paterno",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
            ),
          ),
          const SizedBox(height: 20),

          // =============================
          // APELLIDO MATERNO
          // =============================
          TextFormField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r"[a-zA-ZáéíóúÁÉÍÓÚñÑ ]")),
            ],
            onSaved: (newValue) =>
                widget.tempCliente.apellidoMaterno = newValue,
            validator: (value) {
              final apP = widget.tempCliente.apellidoPaterno;
              if ((value == null || value.isEmpty) &&
                  (apP == null || apP.isEmpty)) {
                return "Debe ingresar al menos un apellido";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Apellido Materno",
              hintText: "Ingresa tu apellido materno",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
            ),
          ),
          const SizedBox(height: 20),

          // =============================
          // LUGAR DE TRABAJO
          // =============================
          TextFormField(
            onSaved: (newValue) => widget.tempCliente.lugarTrabajo = newValue!,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return kLugarTrabajoNullError;
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Lugar de trabajo",
              hintText: "Ingresa tu lugar de trabajo",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon:
                  CustomSurffixIcon(svgIcon: "assets/icons/Briefcase.svg"),
            ),
          ),
          const SizedBox(height: 20),

          // =============================
          // TIPO DE TRABAJO
          // =============================
          TextFormField(
            onSaved: (newValue) => widget.tempCliente.tipoTrabajo = newValue!,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return kTipoTrabajoNullError;
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Tipo de trabajo",
              hintText: "Ingresa tipo de trabajo",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon:
                  CustomSurffixIcon(svgIcon: "assets/icons/Employee.svg"),
            ),
          ),
          const SizedBox(height: 20),

          // =============================
          // INGRESO MENSUAL
          // =============================
          TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
            ],
            onSaved: (newValue) => widget.tempCliente.ingresoMensual =
                double.tryParse(newValue ?? "0") ?? 0,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return kIngresoMensualNullError;
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Ingreso Mensual",
              hintText: "Ingresa tu ingreso mensual",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon:
                  CustomSurffixIcon(svgIcon: "assets/icons/Money_3.svg"),
            ),
          ),
          const SizedBox(height: 20),

          // =============================
          // DIRECCIÓN
          // =============================
          TextFormField(
            onSaved: (newValue) => widget.tempCliente.direccion = newValue!,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return kAddressNullError;
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

          // =============================
          // CORREO (OPCIONAL)
          // =============================
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            onSaved: (newValue) => widget.tempCliente.correo = newValue,
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                if (!emailValidatorRegExp.hasMatch(value)) {
                  return "Correo inválido";
                }
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Correo",
              hintText: "Ingresa tu correo (opcional)",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Email.svg"),
            ),
          ),
          const SizedBox(height: 20),

          // =============================
          // TELÉFONO
          // =============================
          TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(8),
            ],
            onSaved: (newValue) => widget.tempCliente.telefono =
                int.tryParse(newValue ?? "0") ?? 0,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return kPhoneNumberNullError;
              }

              if (value.length != 8) {
                return "Debe tener exactamente 8 dígitos";
              }

              if (!value.startsWith("6") && !value.startsWith("7")) {
                return "Debe iniciar con 6 o 7";
              }

              return null;
            },
            decoration: const InputDecoration(
              labelText: "Número de Teléfono",
              hintText: "Ingresa tu número de teléfono",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon:
                  CustomSurffixIcon(svgIcon: "assets/icons/Cellphone.svg"),
            ),
          ),
          const SizedBox(height: 20),

          FormError(errors: errors),
          const SizedBox(height: 20),

          // =============================
          // BOTÓN REGISTRAR
          // =============================
          ElevatedButton(
            onPressed: isLoading
                ? null
                : () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      setState(() => isLoading = true);

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

                        if (context.mounted) {
                          Navigator.pushReplacementNamed(
                              context, "/register_success");
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error al registrar: $e")),
                          );
                        }
                      } finally {
                        if (mounted) {
                          setState(() => isLoading = false);
                        }
                      }
                    }
                  },
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text("Registrarse"),
          ),
        ],
      ),
    );
  }
}
