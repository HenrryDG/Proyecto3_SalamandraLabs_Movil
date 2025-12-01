import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';
import '../../../services/api_service.dart';
import '../../notificaciones/notificaciones_screen.dart';

/// Botón de notificaciones con contador dinámico que se actualiza desde el backend
class NotificacionBtnWithCounter extends StatefulWidget {
  const NotificacionBtnWithCounter({Key? key}) : super(key: key);

  @override
  State<NotificacionBtnWithCounter> createState() =>
      _NotificacionBtnWithCounterState();
}

class _NotificacionBtnWithCounterState
    extends State<NotificacionBtnWithCounter> {
  int _numOfItems = 0;
  bool _requiereAtencion = false;

  @override
  void initState() {
    super.initState();
    _cargarResumen();
  }

  Future<void> _cargarResumen() async {
    try {
      final resumen = await ApiService().obtenerResumenNotificaciones();
      if (mounted) {
        setState(() {
          _numOfItems = resumen.total;
          _requiereAtencion = resumen.requiereAtencion;
        });
      }
    } catch (e) {
      // Silenciar errores
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: () {
        Navigator.pushNamed(context, NotificacionesScreen.routeName).then((_) {
          // Recargar el contador al volver de la pantalla de notificaciones
          _cargarResumen();
        });
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: kSecondaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset("assets/icons/Bell.svg"),
          ),
          if (_numOfItems > 0)
            Positioned(
              top: -3,
              right: 0,
              child: Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: _requiereAtencion
                      ? const Color(0xFFFF4848)
                      : kPrimaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(width: 1.5, color: Colors.white),
                ),
                child: Center(
                  child: Text(
                    _numOfItems > 99 ? "99+" : "$_numOfItems",
                    style: TextStyle(
                      fontSize: _numOfItems > 99 ? 8 : 12,
                      height: 1,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
