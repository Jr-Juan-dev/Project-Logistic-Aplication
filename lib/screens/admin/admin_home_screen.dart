// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});
  static const String name = 'AdminHomeScreen';

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const String adminName = 'Admin Juan';
    final String greeting = _getGreeting();
    final bool isDesktop = MediaQuery.of(context).size.width > 768;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child:
            isDesktop
                ? _buildDesktopLayout(adminName, greeting)
                : _buildMobileLayout(adminName, greeting),
      ),
    );
  }

  // Layout compacto y centrado para escritorio
  Widget _buildDesktopLayout(String adminName, String greeting) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 900,
          ), // Ancho máximo más pequeño
          margin: const EdgeInsets.symmetric(
            horizontal: 80.0,
          ), // Márgenes laterales
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header administrativo compacto
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFF9485FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, 4),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => _navigateToProfile(context),
                        child: CircleAvatar(
                          radius: 35,
                          backgroundImage: const NetworkImage(
                            'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=1780',
                          ),
                          backgroundColor: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$greeting, $adminName!',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 28,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Panel de Administración - ${_getCurrentDate()}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => _showLogoutDialog(context),
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.white,
                          size: 24,
                        ),
                        tooltip: 'Cerrar sesión',
                      ),
                    ],
                  ),
                ),
              ),

              // Dashboard de estadísticas compacto
              const _AdminDashboard(isDesktop: true),
              const SizedBox(height: 24),

              // Grid de opciones compacto
              _buildCompactOptionsGrid(),

              const SizedBox(height: 20), // Espacio final más pequeño
            ],
          ),
        ),
      ),
    );
  }

  // Grid de opciones compacto para escritorio
  Widget _buildCompactOptionsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Panel de Control Administrativo',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 16),

        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 4.6, // Más ancho y menos alto
          children: [
            _AdminOptionCard(
              title: 'Gestionar Usuarios',
              subtitle: 'Registrar, editar y eliminar usuarios del sistema',
              icon: Icons.people_outline,
              color: const Color(0xFF007BFF),
              onTap: () => _navigateToUserManagement(context),
              isDesktop: true,
            ),
            _AdminOptionCard(
              title: 'Ver Todos los Pedidos',
              subtitle: 'Monitorear estado y ubicación en tiempo real',
              icon: Icons.inventory_2_outlined,
              color: const Color(0xFF28A745),
              onTap: () => _navigateToOrderManagement(context),
              isDesktop: true,
            ),
            _AdminOptionCard(
              title: 'Asignar Transportistas',
              subtitle: 'Gestionar rutas y asignaciones de delivery',
              icon: Icons.local_shipping_outlined,
              color: const Color(0xFFFF6B35),
              onTap: () => _navigateToDriverAssignment(context),
              isDesktop: true,
            ),
            _AdminOptionCard(
              title: 'Reportes de Entregas',
              subtitle: 'Estadísticas y análisis de rendimiento completo',
              icon: Icons.analytics_outlined,
              color: const Color(0xFF9C27B0),
              onTap: () => _navigateToReports(context),
              isDesktop: true,
            ),
            _AdminOptionCard(
              title: 'Gestión de Rutas',
              subtitle: 'Optimizar rutas Cali-Buenaventura de manera eficiente',
              icon: Icons.route_outlined,
              color: const Color(0xFFFFC107),
              onTap: () => _navigateToRouteManagement(context),
              isDesktop: true,
            ),
            _AdminOptionCard(
              title: 'Configuración del Sistema',
              subtitle: 'Ajustes generales y configuraciones avanzadas',
              icon: Icons.settings_outlined,
              color: const Color(0xFF6C757D),
              onTap: () => _navigateToProfile(context),
              isDesktop: true,
            ),
          ],
        ),
      ],
    );
  }

  // Layout original para móvil (sin cambios)
  Widget _buildMobileLayout(String adminName, String greeting) {
    return CustomScrollView(
      slivers: [
        // App Bar administrativo
        SliverAppBar(
          expandedHeight: 140,
          floating: false,
          pinned: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () => _showLogoutDialog(context),
              icon: const Icon(Icons.logout, color: Colors.white),
              tooltip: 'Cerrar sesión',
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF9485FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 12,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => _navigateToProfile(context),
                        child: CircleAvatar(
                          radius: 28,
                          backgroundImage: const NetworkImage(
                            'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=1780',
                          ),
                          backgroundColor: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$greeting, $adminName!',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 22,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Panel de Administración - ${_getCurrentDate()}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // Contenido principal móvil
        SliverList(
          delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dashboard de estadísticas
                  const _AdminDashboard(isDesktop: false),
                  const SizedBox(height: 32),

                  // Sección de Gestión de Usuarios
                  const Text(
                    'Gestión de Usuarios',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _AdminOptionCard(
                    title: 'Gestionar Usuarios',
                    subtitle: 'Registrar, editar y eliminar usuarios',
                    icon: Icons.people_outline,
                    color: const Color(0xFF007BFF),
                    onTap: () => _navigateToUserManagement(context),
                    isDesktop: false,
                  ),

                  const SizedBox(height: 32),

                  // Resto del contenido móvil...
                  const Text(
                    'Gestión de Pedidos',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _AdminOptionCard(
                    title: 'Ver Todos los Pedidos',
                    subtitle: 'Monitorear estado y ubicación en tiempo real',
                    icon: Icons.inventory_2_outlined,
                    color: const Color(0xFF28A745),
                    onTap: () => _navigateToOrderManagement(context),
                    isDesktop: false,
                  ),

                  _AdminOptionCard(
                    title: 'Asignar Transportistas',
                    subtitle: 'Gestionar rutas y asignaciones',
                    icon: Icons.local_shipping_outlined,
                    color: const Color(0xFFFF6B35),
                    onTap: () => _navigateToDriverAssignment(context),
                    isDesktop: false,
                  ),

                  const SizedBox(height: 32),

                  // Sección de Reportes
                  const Text(
                    'Reportes y Analisis',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _AdminOptionCard(
                    title: 'Reportes de Entregas',
                    subtitle: 'Estadísticas y análisis de rendimiento',
                    icon: Icons.analytics_outlined,
                    color: const Color(0xFF9C27B0),
                    onTap: () => _navigateToReports(context),
                    isDesktop: false,
                  ),

                  _AdminOptionCard(
                    title: 'Gestión de Rutas',
                    subtitle: 'Optimizar rutas Cali-Buenaventura',
                    icon: Icons.route_outlined,
                    color: const Color(0xFFFFC107),
                    onTap: () => _navigateToRouteManagement(context),
                    isDesktop: false,
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ]),
        ),
      ],
    );
  }

  // Métodos de navegación
  void _navigateToUserManagement(BuildContext context) {
    context.go('/admin/users');
  }

  void _navigateToOrderManagement(BuildContext context) {
    context.go('/admin/orders');
  }

  void _navigateToDriverAssignment(BuildContext context) {
    context.go('/admin/drivers');
  }

  void _navigateToReports(BuildContext context) {
    context.go('/admin/reports');
  }

  void _navigateToRouteManagement(BuildContext context) {
    context.go('/admin/routes');
  }

  void _navigateToProfile(BuildContext context) {
    context.go('/admin/profile');
  }

  // Diálogo de confirmación de cierre de sesión
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Cerrar Sesión'),
          content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                foregroundColor: Colors.white,
              ),
              child: const Text('Cerrar Sesión'),
            ),
          ],
        );
      },
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Buenos días';
    if (hour < 18) return 'Buenas tardes';
    return 'Buenas noches';
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    final months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];
    final weekdays = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo',
    ];

    return '${weekdays[now.weekday - 1]}, ${now.day} de ${months[now.month - 1]}';
  }
}

// Widget del Dashboard administrativo compacto para desktop
class _AdminDashboard extends StatelessWidget {
  final bool isDesktop;

  const _AdminDashboard({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isDesktop ? 16 : 20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, 4),
            blurRadius: 20,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 20.0 : 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard Administrativo',
              style: TextStyle(
                fontSize: isDesktop ? 18 : 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            SizedBox(height: isDesktop ? 20 : 20),
            isDesktop ? _buildDesktopStats() : _buildMobileStats(),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _AdminStatItem(
          value: '156',
          label: 'Usuarios Activos',
          icon: Icons.people,
          color: const Color(0xFF007BFF),
          isDesktop: true,
        ),
        _AdminStatItem(
          value: '89',
          label: 'Pedidos Hoy',
          icon: Icons.local_shipping,
          color: const Color(0xFF28A745),
          isDesktop: true,
        ),
        _AdminStatItem(
          value: '5',
          label: 'Alertas Pendientes',
          icon: Icons.warning,
          color: const Color(0xFFDC3545),
          isDesktop: true,
        ),
        _AdminStatItem(
          value: '12',
          label: 'Rutas Activas',
          icon: Icons.route,
          color: const Color(0xFF9C27B0),
          isDesktop: true,
        ),
      ],
    );
  }

  Widget _buildMobileStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _AdminStatItem(
          value: '156',
          label: 'Usuarios Activos',
          icon: Icons.people,
          color: const Color(0xFF007BFF),
          isDesktop: false,
        ),
        _AdminStatItem(
          value: '89',
          label: 'Pedidos Hoy',
          icon: Icons.local_shipping,
          color: const Color(0xFF28A745),
          isDesktop: false,
        ),
        _AdminStatItem(
          value: '5',
          label: 'Alertas',
          icon: Icons.warning,
          color: const Color(0xFFDC3545),
          isDesktop: false,
        ),
      ],
    );
  }
}

class _AdminStatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  final bool isDesktop;

  const _AdminStatItem({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: isDesktop ? 60 : 55,
          height: isDesktop ? 60 : 55,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(isDesktop ? 16 : 16),
          ),
          child: Icon(icon, color: color, size: isDesktop ? 26 : 26),
        ),
        SizedBox(height: isDesktop ? 12 : 12),
        Text(
          value,
          style: TextStyle(
            fontSize: isDesktop ? 22 : 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        SizedBox(height: isDesktop ? 6 : 4),
        Text(
          label,
          style: TextStyle(
            fontSize: isDesktop ? 16 : 11,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// Widget de opciones administrativas compacto para desktop
class _AdminOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isDesktop;

  const _AdminOptionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isDesktop ? 100 : null, // Limita la altura en desktop
      child: Container(
        margin: EdgeInsets.only(bottom: isDesktop ? 0 : 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(isDesktop ? 16 : 16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              offset: const Offset(0, 2),
              blurRadius: 10,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(isDesktop ? 16 : 16),
            child: Padding(
              padding: EdgeInsets.all(isDesktop ? 12.0 : 20.0),
              child: Row(
                children: [
                  Container(
                    width: isDesktop ? 80 : 56,
                    height: isDesktop ? 80 : 56,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(isDesktop ? 12 : 16),
                    ),
                    child: Icon(icon, color: color, size: isDesktop ? 24 : 28),
                  ),
                  SizedBox(width: isDesktop ? 14 : 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: isDesktop ? 18 : 16,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                        SizedBox(height: isDesktop ? 4 : 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: isDesktop ? 14 : 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey[400],
                    size: isDesktop ? 20 : 24,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
