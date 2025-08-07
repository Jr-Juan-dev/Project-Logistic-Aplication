import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});
  static const String name = 'UserManagementScreen';

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'todos';

  // Datos de ejemplo de usuarios
  final List<Map<String, dynamic>> _users = [
    {
      'id': 'USR001',
      'name': 'Carlos Rodríguez',
      'email': 'carlos.rodriguez@email.com',
      'phone': '+57 300 123 4567',
      'role': 'Conductor',
      'status': 'activo',
      'avatar': 'CR',
      'createdAt': '2024-01-15',
      'lastAccess': '2024-08-01 09:30',
    },
    {
      'id': 'USR002',
      'name': 'María González',
      'email': 'maria.gonzalez@email.com',
      'phone': '+57 301 987 6543',
      'role': 'Cliente',
      'status': 'activo',
      'avatar': 'MG',
      'createdAt': '2024-02-20',
      'lastAccess': '2024-08-01 14:15',
    },
    {
      'id': 'USR003',
      'name': 'Juan Pérez',
      'email': 'juan.perez@email.com',
      'phone': '+57 302 555 1234',
      'role': 'Conductor',
      'status': 'inactivo',
      'avatar': 'JP',
      'createdAt': '2024-03-10',
      'lastAccess': '2024-07-28 16:45',
    },
    {
      'id': 'USR004',
      'name': 'Ana López',
      'email': 'ana.lopez@email.com',
      'phone': '+57 315 777 8888',
      'role': 'Cliente',
      'status': 'activo',
      'avatar': 'AL',
      'createdAt': '2024-04-05',
      'lastAccess': '2024-08-01 11:20',
    },
  ];

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
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 768;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          margin: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header compacto para desktop
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF6C63FF), Color(0xFF4C46B6)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, 4),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => context.go('/admin'),
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                        tooltip: 'Volver al Panel',
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.people_outline,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Gestión de Usuarios',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 24,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_users.length} usuarios registrados en el sistema',
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

              // Layout en dos columnas para desktop
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Columna izquierda - Controles y estadísticas
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        _buildDesktopSearchAndFilters(),
                        const SizedBox(height: 20),
                        _buildDesktopQuickStats(),
                        const SizedBox(height: 20),
                        _buildDesktopCreateUserButton(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),

                  // Columna derecha - Lista de usuarios
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Lista de Usuarios',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ..._users.map((user) => _UserCard(
                          user: user,
                          onEdit: () => _editUser(user['id']),
                          onDelete: () => _deleteUser(user['id'], user['name']),
                          onToggleStatus: () => _toggleUserStatus(user['id'], user['name']),
                          isDesktop: true,
                        )),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopSearchAndFilters() {
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Buscar y Filtrar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 12),
            
            // Campo de búsqueda más compacto
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar usuarios...',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400], size: 20),
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 16.0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Colors.grey[200]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Colors.grey[200]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Filtros en columna para desktop
            const Text(
              'Filtros:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _FilterChip(
                  label: 'Todos',
                  isSelected: _selectedFilter == 'todos',
                  onTap: () => setState(() => _selectedFilter = 'todos'),
                ),
                _FilterChip(
                  label: 'Conductores',
                  isSelected: _selectedFilter == 'conductor',
                  onTap: () => setState(() => _selectedFilter = 'conductor'),
                ),
                _FilterChip(
                  label: 'Clientes',
                  isSelected: _selectedFilter == 'cliente',
                  onTap: () => setState(() => _selectedFilter = 'cliente'),
                ),
                _FilterChip(
                  label: 'Activos',
                  isSelected: _selectedFilter == 'activo',
                  onTap: () => setState(() => _selectedFilter = 'activo'),
                ),
                _FilterChip(
                  label: 'Inactivos',
                  isSelected: _selectedFilter == 'inactivo',
                  onTap: () => setState(() => _selectedFilter = 'inactivo'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopQuickStats() {
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estadísticas',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                _StatItem(
                  value: '4',
                  label: 'Total Usuarios',
                  icon: Icons.people,
                  color: const Color(0xFF6C63FF),
                  isCompact: true,
                ),
                const SizedBox(height: 12),
                _StatItem(
                  value: '2',
                  label: 'Conductores',
                  icon: Icons.local_shipping,
                  color: const Color(0xFF28A745),
                  isCompact: true,
                ),
                const SizedBox(height: 12),
                _StatItem(
                  value: '2',
                  label: 'Clientes',
                  icon: Icons.person,
                  color: const Color(0xFF007BFF),
                  isCompact: true,
                ),
                const SizedBox(height: 12),
                _StatItem(
                  value: '3',
                  label: 'Activos',
                  icon: Icons.check_circle,
                  color: const Color(0xFF20C997),
                  isCompact: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopCreateUserButton() {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF28A745), Color(0xFF20A13A)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF28A745).withOpacity(0.3),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () => context.go('/admin/users/create'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        icon: const Icon(Icons.add, color: Colors.white, size: 20),
        label: const Text(
          'Crear Usuario',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return CustomScrollView(
      slivers: [
        // App Bar personalizado
        SliverAppBar(
          expandedHeight: 120,
          floating: false,
          pinned: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () => context.go('/admin'),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF6C63FF), Color(0xFF4C46B6)],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.people_outline,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Gestión de Usuarios',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_users.length} usuarios registrados',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w400,
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
                  // Barra de búsqueda y filtros
                  _buildMobileSearchAndFilters(),
                  const SizedBox(height: 24),

                  // Estadísticas rápidas
                  _buildMobileQuickStats(),
                  const SizedBox(height: 32),

                  // Botón para crear usuario
                  _buildMobileCreateUserButton(),
                  const SizedBox(height: 24),

                  // Lista de usuarios
                  const Text(
                    'Lista de Usuarios',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 16),

                  ..._users.map((user) => _UserCard(
                    user: user,
                    onEdit: () => _editUser(user['id']),
                    onDelete: () => _deleteUser(user['id'], user['name']),
                    onToggleStatus: () => _toggleUserStatus(user['id'], user['name']),
                    isDesktop: false,
                  )),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ]),
        ),
      ],
    );
  }

  Widget _buildMobileSearchAndFilters() {
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
          children: [
            // Campo de búsqueda
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre, email o teléfono...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 20.0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Colors.grey[200]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Colors.grey[200]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Filtros
            Row(
              children: [
                const Text(
                  'Filtrar por:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterChip(
                          label: 'Todos',
                          isSelected: _selectedFilter == 'todos',
                          onTap: () => setState(() => _selectedFilter = 'todos'),
                        ),
                        _FilterChip(
                          label: 'Conductores',
                          isSelected: _selectedFilter == 'conductor',
                          onTap: () => setState(() => _selectedFilter = 'conductor'),
                        ),
                        _FilterChip(
                          label: 'Clientes',
                          isSelected: _selectedFilter == 'cliente',
                          onTap: () => setState(() => _selectedFilter = 'cliente'),
                        ),
                        _FilterChip(
                          label: 'Activos',
                          isSelected: _selectedFilter == 'activo',
                          onTap: () => setState(() => _selectedFilter = 'activo'),
                        ),
                        _FilterChip(
                          label: 'Inactivos',
                          isSelected: _selectedFilter == 'inactivo',
                          onTap: () => setState(() => _selectedFilter = 'inactivo'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileQuickStats() {
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatItem(
              value: '4',
              label: 'Total Usuarios',
              icon: Icons.people,
              color: const Color(0xFF6C63FF),
              isCompact: false,
            ),
            _StatItem(
              value: '2',
              label: 'Conductores',
              icon: Icons.local_shipping,
              color: const Color(0xFF28A745),
              isCompact: false,
            ),
            _StatItem(
              value: '2',
              label: 'Clientes',
              icon: Icons.person,
              color: const Color(0xFF007BFF),
              isCompact: false,
            ),
            _StatItem(
              value: '3',
              label: 'Activos',
              icon: Icons.check_circle,
              color: const Color(0xFF20C997),
              isCompact: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileCreateUserButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF28A745), Color(0xFF20A13A)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF28A745).withOpacity(0.3),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () => context.go('/admin/users/create'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Crear Nuevo Usuario',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  // Funciones de acciones (solo muestran mensajes de confirmación)
  void _editUser(String userId) {
    context.go('/admin/users/edit/$userId');
  }

  void _deleteUser(String userId, String userName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Eliminar Usuario'),
          content: Text('¿Estás seguro de que quieres eliminar a $userName?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showSuccessMessage('Usuario $userName eliminado correctamente');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC3545),
                foregroundColor: Colors.white,
              ),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _toggleUserStatus(String userId, String userName) {
    _showSuccessMessage('Estado de $userName actualizado correctamente');
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFF28A745),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

// Widget para los chips de filtro
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF6C63FF) : Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? const Color(0xFF6C63FF) : Colors.grey[300]!,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[700],
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

// Widget para las estadísticas
class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  final bool isCompact;

  const _StatItem({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// Widget para cada tarjeta de usuario
class _UserCard extends StatelessWidget {
  final Map<String, dynamic> user;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleStatus;
  final bool isDesktop;

  const _UserCard({
    required this.user,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
    this.isDesktop = false,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = user['status'] == 'activo';
    
    return Container(
      margin: EdgeInsets.only(bottom: isDesktop ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isDesktop ? 12 : 16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            offset: const Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 16.0 : 20.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Container(
                  width: isDesktop ? 48 : 56,
                  height: isDesktop ? 48 : 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF6C63FF),
                        const Color(0xFF6C63FF).withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(isDesktop ? 12 : 16),
                  ),
                  child: Center(
                    child: Text(
                      user['avatar'],
                      style: TextStyle(
                        fontSize: isDesktop ? 16 : 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: isDesktop ? 12 : 16),

                // Información del usuario
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              user['name'],
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: isDesktop ? 15 : 16,
                                color: const Color(0xFF1A1A1A),
                              ),
                            ),
                          ),
                          // Estado
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isDesktop ? 10 : 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isActive 
                                ? const Color(0xFF28A745).withOpacity(0.1)
                                : const Color(0xFFDC3545).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              isActive ? 'ACTIVO' : 'INACTIVO',
                              style: TextStyle(
                                fontSize: isDesktop ? 9 : 10,
                                fontWeight: FontWeight.w600,
                                color: isActive 
                                  ? const Color(0xFF28A745)
                                  : const Color(0xFFDC3545),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user['email'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: isDesktop ? 13 : 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user['phone'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: isDesktop ? 13 : 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isDesktop ? 6 : 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF007BFF).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              user['role'].toUpperCase(),
                              style: TextStyle(
                                fontSize: isDesktop ? 9 : 10,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF007BFF),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'ID: ${user['id']}',
                            style: TextStyle(
                              fontSize: isDesktop ? 11 : 12,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: isDesktop ? 12 : 16),

            // Información adicional
            Container(
              padding: EdgeInsets.all(isDesktop ? 10 : 12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Registrado',
                        style: TextStyle(
                          fontSize: isDesktop ? 11 : 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        user['createdAt'],
                        style: TextStyle(
                          fontSize: isDesktop ? 11 : 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Último acceso',
                        style: TextStyle(
                          fontSize: isDesktop ? 11 : 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        user['lastAccess'],
                        style: TextStyle(
                          fontSize: isDesktop ? 11 : 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: isDesktop ? 12 : 16),

            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onEdit,
                    icon: Icon(Icons.edit_outlined, size: isDesktop ? 16 : 18),
                    label: const Text('Editar'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF6C63FF),
                      side: const BorderSide(color: Color(0xFF6C63FF)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: Size(0, isDesktop ? 32 : 36),
                      textStyle: TextStyle(fontSize: isDesktop ? 12 : 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onToggleStatus,
                    icon: Icon(
                      isActive ? Icons.pause : Icons.play_arrow,
                      size: isDesktop ? 16 : 18,
                    ),
                    label: Text(isActive ? 'Desactivar' : 'Activar'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isActive 
                        ? const Color(0xFFFFC107) 
                        : const Color(0xFF28A745),
                      side: BorderSide(
                        color: isActive 
                          ? const Color(0xFFFFC107) 
                          : const Color(0xFF28A745),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: Size(0, isDesktop ? 32 : 36),
                      textStyle: TextStyle(fontSize: isDesktop ? 12 : 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: onDelete,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFDC3545),
                    side: const BorderSide(color: Color(0xFFDC3545)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size(isDesktop ? 40 : 48, isDesktop ? 32 : 36),
                  ),
                  child: Icon(Icons.delete_outline, size: isDesktop ? 16 : 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  } 
}