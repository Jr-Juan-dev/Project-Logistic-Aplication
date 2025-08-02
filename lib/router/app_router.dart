import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:topax/screens/barra_navegacion/barra_nav_inferior.dart';
import 'package:topax/screens/history_screen.dart';
import 'package:topax/screens/home_screen.dart';
import 'package:topax/screens/login_screen.dart';
import 'package:topax/screens/profile_screen.dart';
import 'package:topax/screens/qr_scanner_screen.dart';
import 'package:topax/screens/tracking_screen.dart';

// Configuración de GoRouter
final GoRouter appRouter = GoRouter(
  initialLocation: '/login', // La ruta inicial
  routes: [
    // Rutas que NO muestran la barra de navegación inferior
    GoRoute(
      path: '/login',
      name: LoginScreen.name,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/qr-scanner',
      name: QRScannerScreen.name,
      builder: (context, state) => const QRScannerScreen(),
    ),

    // ShellRoute para las pantallas CON la barra de navegación inferior
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return BarraNavInferior(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          name: HomeScreen.name,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/history',
          name: HistoryScreen.name,
          builder: (context, state) => const HistoryScreen(),
        ),
        GoRoute(
          path: '/tracking', 
          name: TrackingScreen.name,
          builder: (context, state) => const TrackingScreen(),
        ),
        GoRoute(
          path: '/perfil',
          name: ProfileScreen.name,
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);