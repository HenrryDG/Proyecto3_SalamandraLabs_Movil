import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/home/home_screen.dart';
import 'package:shop_app/screens/profile/profile_screen.dart';
import 'package:shop_app/screens/solicitudes/solicitudes_screen.dart';
import 'package:shop_app/screens/prestamos/prestamos_screen.dart';
import 'package:shop_app/screens/notificaciones/notificaciones_screen.dart';
import 'package:shop_app/services/api_service.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  static String routeName = "/";

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  int currentSelectedIndex = 0;
  int _notificationCount = 0;

  @override
  void initState() {
    super.initState();
    _cargarContadorNotificaciones();
  }

  Future<void> _cargarContadorNotificaciones() async {
    try {
      final notificaciones = await ApiService().obtenerMisNotificaciones();
      if (mounted) {
        setState(() {
          _notificationCount = notificaciones.length;
        });
      }
    } catch (e) {
      // Ignorar errores silenciosamente
    }
  }

  void updateCurrentIndex(int index) {
    setState(() {
      currentSelectedIndex = index;
    });
    // Recargar contador al cambiar de tab
    _cargarContadorNotificaciones();
  }

  List<Widget> _buildPages() {
    return [
      HomeScreen(onNavigateToTab: updateCurrentIndex),
      const SolicitudesScreen(),
      const PrestamosScreen(),
      const NotificacionesScreen(),
      const ProfileScreen()
    ];
  }

  @override
  Widget build(BuildContext context) {
    final pages = _buildPages();
    return Scaffold(
      body: pages[currentSelectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: updateCurrentIndex,
        currentIndex: currentSelectedIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/Shop Icon.svg",
              colorFilter: const ColorFilter.mode(
                inActiveIconColor,
                BlendMode.srcIn,
              ),
            ),
            activeIcon: SvgPicture.asset(
              "assets/icons/Shop Icon.svg",
              colorFilter: const ColorFilter.mode(
                kPrimaryColor,
                BlendMode.srcIn,
              ),
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/receipt.svg",
              colorFilter: const ColorFilter.mode(
                inActiveIconColor,
                BlendMode.srcIn,
              ),
            ),
            activeIcon: SvgPicture.asset(
              "assets/icons/receipt.svg",
              colorFilter: const ColorFilter.mode(
                kPrimaryColor,
                BlendMode.srcIn,
              ),
            ),
            label: "Solicitudes",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/Cash.svg",
              colorFilter: const ColorFilter.mode(
                inActiveIconColor,
                BlendMode.srcIn,
              ),
            ),
            activeIcon: SvgPicture.asset(
              "assets/icons/Cash.svg",
              colorFilter: const ColorFilter.mode(
                kPrimaryColor,
                BlendMode.srcIn,
              ),
            ),
            label: "Préstamos",
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                SvgPicture.asset(
                  "assets/icons/Bell.svg",
                  colorFilter: const ColorFilter.mode(
                    inActiveIconColor,
                    BlendMode.srcIn,
                  ),
                ),
                if (_notificationCount > 0)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: Text(
                        _notificationCount > 9 ? '9+' : '$_notificationCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            activeIcon: Stack(
              clipBehavior: Clip.none,
              children: [
                SvgPicture.asset(
                  "assets/icons/Bell.svg",
                  colorFilter: const ColorFilter.mode(
                    kPrimaryColor,
                    BlendMode.srcIn,
                  ),
                ),
                if (_notificationCount > 0)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: Text(
                        _notificationCount > 9 ? '9+' : '$_notificationCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: "Notificaciones",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/User Icon.svg",
              colorFilter: const ColorFilter.mode(
                inActiveIconColor,
                BlendMode.srcIn,
              ),
            ),
            activeIcon: SvgPicture.asset(
              "assets/icons/User Icon.svg",
              colorFilter: const ColorFilter.mode(
                kPrimaryColor,
                BlendMode.srcIn,
              ),
            ),
            label: "Perfil",
          ),
        ],
      ),
    );
  }
}
