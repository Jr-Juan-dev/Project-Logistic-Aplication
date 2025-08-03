import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:topax/screens/login_screen.dart';
import 'package:topax/screens/home_screen.dart';
import 'package:topax/screens/admin/admin_home_screen.dart';
import 'package:topax/screens/profile_screen.dart';
import 'package:topax/screens/history_screen.dart';
import 'package:topax/screens/tracking_screen.dart';
import 'package:topax/screens/qr_scanner_screen.dart';
import 'package:topax/screens/barra_navigacion/barra_nav_inferior.dart';

// Importaciones para las pantallas de gestión de usuarios
import 'package:topax/screens/admin/users/user_management_screen.dart';
import 'package:topax/screens/admin/users/create_user_screen.dart';
import 'package:topax/screens/admin/users/edit_user_screen.dart';

// Importaciones para las pantallas de gestión de pedidos
import 'package:topax/screens/admin/orders/order_management_screen.dart';
import 'package:topax/screens/admin/orders/order_details_screen.dart';
import 'package:topax/screens/admin/orders/create_order_screen.dart';

// Importaciones para las pantallas de asignación de conductores
import 'package:topax/screens/admin/drivers/driver_assignment_screen.dart';
import 'package:topax/screens/admin/drivers/assign_driver_screen.dart';

// Importaciones para las pantallas de reportes
import 'package:topax/screens/admin/reports/reports_screen.dart';
import 'package:topax/screens/admin/reports/delivery_reports_screen.dart';
import 'package:topax/screens/admin/reports/performance_reports_screen.dart';
import 'package:topax/screens/admin/reports/analytics_screen.dart';

// Importaciones para las pantallas de gestión de rutas
import 'package:topax/screens/admin/routes/route_management_screen.dart';
import 'package:topax/screens/admin/routes/route_optimization_screen.dart';
import 'package:topax/screens/admin/routes/route_tracking_screen.dart';

// Importaciones para pantallas administrativas adicionales
import 'package:topax/screens/admin/admin_profile_screen.dart';

// Importación para pantalla de error
import 'package:topax/screens/error_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    // ============ RUTAS SIN BARRA INFERIOR ============
    GoRoute(
      path: '/login',
      name: LoginScreen.name,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/scanner',
      name: QRScannerScreen.name,
      builder: (context, state) => const QRScannerScreen(),
    ),

    // ============ SHELL PARA BARRA DE NAVEGACIÓN ============
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

    // ============ RUTAS ADMINISTRATIVAS ============
    GoRoute(
      path: '/admin',
      name: AdminHomeScreen.name,
      builder: (context, state) => const AdminHomeScreen(),
    ),
    GoRoute(
      path: '/admin/profile',
      name: 'AdminProfileScreen',
      builder: (context, state) => const AdminProfileScreen(),
    ),

    // ========== GESTIÓN DE USUARIOS ==========
    GoRoute(
      path: '/admin/users',
      name: 'UserManagementScreen',
      builder: (context, state) => const UserManagementScreen(),
    ),
    GoRoute(
      path: '/admin/users/create',
      name: 'CreateUserScreen',
      builder: (context, state) => const CreateUserScreen(),
    ),
    GoRoute(
      path: '/admin/users/edit/:userId',
      name: 'EditUserScreen',
      builder: (context, state) {
        final userId = state.pathParameters['userId']!;
        return EditUserScreen(userId: userId);
      },
    ),

    // ========== GESTIÓN DE PEDIDOS ==========
    GoRoute(
      path: '/admin/orders',
      name: 'OrderManagementScreen',
      builder: (context, state) => const OrderManagementScreen(),
    ),
    GoRoute(
      path: '/admin/orders/details/:orderId',
      name: 'OrderDetailsScreen',
      builder: (context, state) {
        final orderId = state.pathParameters['orderId']!;
        return OrderDetailsScreen(orderId: orderId);
      },
    ),
    GoRoute(
      path: '/admin/orders/create',
      name: 'CreateOrderScreen',
      builder: (context, state) => const CreateOrderScreen(),
    ),

    // ========== ASIGNACIÓN DE CONDUCTORES ==========
    GoRoute(
      path: '/admin/drivers',
      name: 'DriverAssignmentScreen',
      builder: (context, state) => const DriverAssignmentScreen(),
    ),
    GoRoute(
      path: '/admin/drivers/assign/:orderId',
      name: 'AssignDriverScreen',
      builder: (context, state) {
        final orderId = state.pathParameters['orderId']!;
        return AssignDriverScreen(orderId: orderId);
      },
    ),

    // ========== REPORTES Y ANALYTICS ==========
    GoRoute(
      path: '/admin/reports',
      name: 'ReportsScreen',
      builder: (context, state) => const ReportsScreen(),
    ),
    GoRoute(
      path: '/admin/reports/delivery',
      name: 'DeliveryReportsScreen',
      builder: (context, state) => const DeliveryReportsScreen(),
    ),
    GoRoute(
      path: '/admin/reports/performance',
      name: 'PerformanceReportsScreen',
      builder: (context, state) => const PerformanceReportsScreen(),
    ),
    GoRoute(
      path: '/admin/reports/analytics',
      name: 'AnalyticsScreen',
      builder: (context, state) => const AnalyticsScreen(),
    ),

    // ========== GESTIÓN DE RUTAS ==========
    GoRoute(
      path: '/admin/routes',
      name: 'RouteManagementScreen',
      builder: (context, state) => const RouteManagementScreen(),
    ),
    GoRoute(
      path: '/admin/routes/optimize',
      name: 'RouteOptimizationScreen',
      builder: (context, state) => const RouteOptimizationScreen(),
    ),
    GoRoute(
      path: '/admin/routes/tracking',
      name: 'RouteTrackingScreen',
      builder: (context, state) => const RouteTrackingScreen(),
    ),

    // ============ RUTA PARA ERRORES ============
    GoRoute(
      path: '/error',
      name: 'ErrorScreen',
      builder: (context, state) => const ErrorScreen(),
    ),
  ],
  errorBuilder: (context, state) => const ErrorScreen(),
);
