import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key, required String driverId});
  static const String name = 'DriverProfileScreen';

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 768;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: isDesktop ? _buildDesktopLayout(context) : _buildMobileLayout(context),
    );
  }

  // Layout compacto y centrado para escritorio
  Widget _buildDesktopLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 900), // Ancho máximo más pequeño
          margin: const EdgeInsets.symmetric(horizontal: 80.0), // Márgenes laterales considerables
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header del perfil compacto
              _buildCompactProfileHeader(context),
              
              const SizedBox(height: 20),
              
              // Contenido en dos columnas
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Columna izquierda - Información del administrador
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildSectionTitle(context, 'Información del Administrador', isDesktop: true),
                        _buildInfoCard(isDesktop: true),
                        const SizedBox(height: 24),
                        _buildLogoutButton(context, isDesktop: true),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 24),
                  
                  // Columna derecha - Estadísticas y actividad
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildSectionTitle(context, 'Actividad de Hoy', isDesktop: true),
                        _buildStatsGrid(isDesktop: true),
                        const SizedBox(height: 20),
                        _buildAdditionalStats(isDesktop: true),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 40), // Espacio final compacto
            ],
          ),
        ),
      ),
    );
  }

  // Header compacto del perfil para desktop
  Widget _buildCompactProfileHeader(BuildContext context) {
    const String userName = 'Juan Pérez';
    const String userEmail = 'juan.perez@topax.com';
    const String userRole = 'Operador Logístico';
    const String coverImageUrl = 'https://images.unsplash.com/photo-1553095066-5014bc7b7f2d?q=80&w=2071';
    const String profileImageUrl = 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=1780';

    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 20),
      height: 200, // Altura compacta
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 20,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Imagen de fondo
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: const NetworkImage(coverImageUrl),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          
          // Contenido del perfil
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                // Foto de perfil compacta
                GestureDetector(
                  onTap: () => _showImageOptions(context, 'perfil', true),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(0, 4),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 42,
                        backgroundImage: const NetworkImage(profileImageUrl),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(0.2),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 24),
                
                // Información del usuario
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          userEmail,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        userRole,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Botón de editar portada
                GestureDetector(
                  onTap: () => _showImageOptions(context, 'portada', true),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Layout original para móvil (sin cambios)
  Widget _buildMobileLayout(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(context, isDesktop: false),
        SliverList(
          delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSectionTitle(context, 'Información del Administrador', isDesktop: false),
                  _buildInfoCard(isDesktop: false),
                  const SizedBox(height: 24),
                  _buildSectionTitle(context, 'Actividad de Hoy', isDesktop: false),
                  _buildStatsGrid(isDesktop: false),
                  const SizedBox(height: 24),
                  _buildLogoutButton(context, isDesktop: false),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ]),
        ),
      ],
    );
  }

  // AppBar flexible para móvil (sin cambios)
  Widget _buildSliverAppBar(BuildContext context, {required bool isDesktop}) {
    const String userName = 'Juan Pérez';
    const String userEmail = 'juan.perez@topax.com';
    const String userRole = 'Operador Logístico';
    const String coverImageUrl =
        'https://images.unsplash.com/photo-1553095066-5014bc7b7f2d?q=80&w=2071';
    const String profileImageUrl =
        'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=1780';

    const Color primaryBlue = Color(0xFF007BFF);

    return SliverAppBar(
      expandedHeight: isDesktop ? 400.0 : 280.0,
      floating: false,
      pinned: true,
      backgroundColor: primaryBlue,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 16 : 8,
            vertical: isDesktop ? 8 : 4,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(isDesktop ? 16 : 12),
          ),
          child: Text(
            userName,
            style: TextStyle(
              color: Colors.white,
              fontSize: isDesktop ? 20.0 : 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Portada con gradiente
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const NetworkImage(coverImageUrl),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.4),
                    BlendMode.darken,
                  ),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
                ),
              ),
            ),

            // Contenido del perfil
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Foto de perfil con borde y sombra
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(0, 4),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () => _showImageOptions(context, 'perfil', isDesktop),
                      child: CircleAvatar(
                        radius: isDesktop ? 72 : 52,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: isDesktop ? 68 : 48,
                          backgroundImage: const NetworkImage(profileImageUrl),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withOpacity(0.1),
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: isDesktop ? 28 : 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: isDesktop ? 20 : 12),

                  // Email con fondo semitransparente
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 20 : 12,
                      vertical: isDesktop ? 10 : 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(isDesktop ? 20 : 16),
                    ),
                    child: Text(
                      userEmail,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.95),
                        fontSize: isDesktop ? 18 : 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  SizedBox(height: isDesktop ? 8 : 4),

                  // Rol del usuario
                  Text(
                    userRole,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: isDesktop ? 16 : 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            // Botón de editar portada
            Positioned(
              top: isDesktop ? 120 : 100,
              right: isDesktop ? 32 : 16,
              child: GestureDetector(
                onTap: () => _showImageOptions(context, 'portada', isDesktop),
                child: Container(
                  padding: EdgeInsets.all(isDesktop ? 12 : 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(isDesktop ? 24 : 20),
                  ),
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: isDesktop ? 20 : 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tarjeta con información clave del administrador - Compacta
  Widget _buildInfoCard({required bool isDesktop}) {
    return Container(
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
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 20.0 : 20.0),
        child: Column(
          children: [
            _InfoRow(
              icon: Icons.badge_outlined,
              label: 'ID de Empleado',
              value: 'EMP-12345',
              color: const Color(0xFF007BFF),
              isDesktop: isDesktop,
            ),
            SizedBox(height: isDesktop ? 16 : 16),
            Divider(height: 1, color: Colors.grey[200]),
            SizedBox(height: isDesktop ? 16 : 16),
            _InfoRow(
              icon: Icons.work_outline,
              label: 'Cargo',
              value: 'Operador Logístico',
              color: const Color(0xFF28A745),
              isDesktop: isDesktop,
            ),
            SizedBox(height: isDesktop ? 16 : 16),
            Divider(height: 1, color: Colors.grey[200]),
            SizedBox(height: isDesktop ? 16 : 16),
            _InfoRow(
              icon: Icons.access_time,
              label: 'Turno',
              value: '7:00 AM - 3:00 PM',
              color: const Color(0xFFDC3545),
              isDesktop: isDesktop,
            ),
            if (isDesktop) ...[
              SizedBox(height: isDesktop ? 16 : 16),
              Divider(height: 1, color: Colors.grey[200]),
              SizedBox(height: isDesktop ? 16 : 16),
              _InfoRow(
                icon: Icons.location_on_outlined,
                label: 'Ubicación',
                value: 'Buenaventura, Valle del Cauca',
                color: const Color(0xFF9C27B0),
                isDesktop: isDesktop,
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Grid con estadísticas de actividad - Compacto
  Widget _buildStatsGrid({required bool isDesktop}) {
    if (isDesktop) {
      return Column(
        children: const [
          _StatCard(
            label: 'Gestiones Realizadas',
            value: '25',
            icon: Icons.check_circle_outline,
            color: Color(0xFF007BFF),
            backgroundColor: Color(0xFFE3F2FD),
            isDesktop: true,
          ),
          SizedBox(height: 12),
          _StatCard(
            label: 'Pedidos Procesados',
            value: '18',
            icon: Icons.assignment_turned_in,
            color: Color(0xFF28A745),
            backgroundColor: Color(0xFFE8F5E8),
            isDesktop: true,
          ),
        ],
      );
    }
    
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: const [
        _StatCard(
          label: 'Gestiones Realizadas',
          value: '25',
          icon: Icons.check_circle_outline,
          color: Color(0xFF007BFF),
          backgroundColor: Color(0xFFE3F2FD),
          isDesktop: false,
        ),
        _StatCard(
          label: 'Otros',
          value: '5',
          icon: Icons.assignment_turned_in,
          color: Color(0xFF28A745),
          backgroundColor: Color(0xFFE8F5E8),
          isDesktop: false,
        ),
      ],
    );
  }

  // Estadísticas adicionales para escritorio - Compactas
  Widget _buildAdditionalStats({required bool isDesktop}) {
    if (!isDesktop) return const SizedBox.shrink();
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            offset: const Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumen Semanal',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 16),
            _buildProgressItem('Eficiencia', 0.85, const Color(0xFF007BFF)),
            const SizedBox(height: 12),
            _buildProgressItem('Puntualidad', 0.92, const Color(0xFF28A745)),
            const SizedBox(height: 12),
            _buildProgressItem('Satisfacción', 0.78, const Color(0xFFFF6B35)),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressItem(String label, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 5,
        ),
      ],
    );
  }

  // Widget para los títulos de cada sección - Compactos
  Widget _buildSectionTitle(BuildContext context, String title, {required bool isDesktop}) {
    return Padding(
      padding: EdgeInsets.only(
        left: 4.0,
        bottom: isDesktop ? 12.0 : 12.0,
        top: isDesktop ? 8.0 : 8.0,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: isDesktop ? 18 : 18,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF1A1A1A),
          letterSpacing: -0.3,
        ),
      ),
    );
  }

  // Widget para el botón de cerrar sesión - Compacto
  Widget _buildLogoutButton(BuildContext context, {required bool isDesktop}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade400, Colors.red.shade600],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(isDesktop ? 12 : 12),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: ElevatedButton.icon(
        icon: Icon(
          Icons.logout,
          color: Colors.white,
          size: isDesktop ? 20 : 20,
        ),
        label: Text(
          'Cerrar Sesión',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: isDesktop ? 16 : 16,
          ),
        ),
        onPressed: () => _showLogoutConfirmationDialog(context, isDesktop),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isDesktop ? 12 : 12),
          ),
          padding: EdgeInsets.symmetric(
            vertical: isDesktop ? 16 : 16,
            horizontal: isDesktop ? 20 : 16,
          ),
        ),
      ),
    );
  }

  // Muestra el ModalBottomSheet con opciones para la imagen
  void _showImageOptions(BuildContext context, String imageType, bool isDesktop) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF007BFF).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.photo_library_outlined,
                      color: Color(0xFF007BFF),
                    ),
                  ),
                  title: Text(
                    'Ver foto de ${imageType == 'perfil' ? 'perfil' : 'portada'}',
                    style: TextStyle(fontSize: isDesktop ? 16 : 14),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF28A745).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.edit_outlined,
                      color: Color(0xFF28A745),
                    ),
                  ),
                  title: Text(
                    'Cambiar foto de ${imageType == 'perfil' ? 'perfil' : 'portada'}',
                    style: TextStyle(fontSize: isDesktop ? 16 : 14),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.delete_outline, color: Colors.red),
                  ),
                  title: Text(
                    'Eliminar foto de ${imageType == 'perfil' ? 'perfil' : 'portada'}',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: isDesktop ? 16 : 14,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(height: isDesktop ? 20 : 16),
              ],
            ),
          ),
        );
      },
    );
  }

  // Muestra diálogo de confirmación para cerrar sesión
  void _showLogoutConfirmationDialog(BuildContext context, bool isDesktop) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Cerrar Sesión',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: isDesktop ? 18 : 16,
            ),
          ),
          content: Text(
            '¿Estás seguro de que deseas cerrar sesión? Tendrás que volver a autenticarte.',
            style: TextStyle(
              height: 1.4,
              fontSize: isDesktop ? 14 : 14,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: isDesktop ? 14 : 14,
                ),
              ),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 16 : 16,
                  vertical: isDesktop ? 10 : 8,
                ),
              ),
              child: Text(
                'Cerrar Sesión',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isDesktop ? 14 : 14,
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.go('/login');
              },
            ),
          ],
        );
      },
    );
  }
}

// Widget para una fila de información (label: valor) - Compacta
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isDesktop;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(isDesktop ? 10 : 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(isDesktop ? 10 : 8),
          ),
          child: Icon(
            icon,
            color: color,
            size: isDesktop ? 20 : 20,
          ),
        ),
        SizedBox(width: isDesktop ? 16 : 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: isDesktop ? 13 : 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: isDesktop ? 3 : 2),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: isDesktop ? 15 : 15,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Widget para una tarjeta de estadística - Compacta
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final bool isDesktop;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.backgroundColor,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 16.0 : 16.0),
        child: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 24, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 24, color: color),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}