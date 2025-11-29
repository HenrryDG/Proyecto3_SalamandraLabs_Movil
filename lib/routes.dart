import 'package:flutter/widgets.dart';
import 'package:shop_app/screens/products/products_screen.dart';
import 'package:shop_app/helper/auth_guard.dart';

import 'screens/account/account_info_screen.dart';
import 'screens/cart/cart_screen.dart';
import 'screens/complete_profile/complete_profile_screen.dart';
import 'screens/details/details_screen.dart';
import 'screens/forgot_password/forgot_password_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/init_screen.dart';
import 'screens/login_success/login_success_screen.dart';
import 'package:shop_app/screens/register_success/register_success_screen.dart';
import 'screens/otp/otp_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/sign_in/sign_in_screen.dart';
import 'screens/sign_up/sign_up_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'package:shop_app/screens/sign_in/auth_wrapper.dart';
import 'screens/solicitudes/solicitudes_screen.dart';
import 'screens/solicitudes/solicitud_detalle_screen.dart';
import 'screens/prestamos/prestamos_screen.dart';
import 'screens/prestamos/plan_pagos_screen.dart';

// We use name route
// al final de tus imports
final Map<String, WidgetBuilder> routes = {
  // Rutas públicas (no requieren autenticación)
  AuthWrapper.routeName: (context) => const AuthWrapper(),
  SplashScreen.routeName: (context) => const SplashScreen(),
  SignInScreen.routeName: (context) => const SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
  SignUpScreen.routeName: (context) => const SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => const CompleteProfileScreen(),
  RegisterSuccessScreen.routeName: (context) => const RegisterSuccessScreen(),

  // Rutas protegidas (requieren autenticación)
  InitScreen.routeName: (context) => const AuthGuard(child: InitScreen()),
  LoginSuccessScreen.routeName: (context) =>
      const AuthGuard(child: LoginSuccessScreen()),
  OtpScreen.routeName: (context) => const AuthGuard(child: OtpScreen()),
  HomeScreen.routeName: (context) => const AuthGuard(child: HomeScreen()),
  ProductsScreen.routeName: (context) =>
      const AuthGuard(child: ProductsScreen()),
  DetailsScreen.routeName: (context) => const AuthGuard(child: DetailsScreen()),
  CartScreen.routeName: (context) => const AuthGuard(child: CartScreen()),
  ProfileScreen.routeName: (context) => const AuthGuard(child: ProfileScreen()),
  AccountInfoScreen.routeName: (context) =>
      const AuthGuard(child: AccountInfoScreen()),
  SolicitudesScreen.routeName: (context) =>
      const AuthGuard(child: SolicitudesScreen()),
  SolicitudDetalleScreen.routeName: (context) =>
      const AuthGuard(child: SolicitudDetalleScreen()),
  PrestamosScreen.routeName: (context) =>
      const AuthGuard(child: PrestamosScreen()),
  PlanPagosScreen.routeName: (context) =>
      const AuthGuard(child: PlanPagosScreen()),
};
