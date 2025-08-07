import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DriverAssignmentScreen extends StatefulWidget {
  const DriverAssignmentScreen({super.key});
  static const String name = 'DriverAssignmentScreen';

  @override
  State<DriverAssignmentScreen> createState() => _DriverAssignmentScreenState();
}

class _DriverAssignmentScreenState extends State<DriverAssignmentScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'todos';

  // Datos de ejemplo de conductores
  final List<Map<String, dynamic>> _drivers = [
    {
      'id': 'DRV001',
      'name': 'Carlos Rodríguez',
      'phone': '+57 300 123 4567',
      'email': 'carlos.rodriguez@email.com',
      'vehiclePlate': 'ABC-123',
      'vehicleType': 'Camión',
      'vehicleModel': 'Chevrolet NPR 2020',
      'status': 'disponible',
      'currentLocation': 'Cali - Centro',
      'rating': 4.8,
      'totalDeliveries': 156,
      'licenseType': 'C2',
      'joinDate': '2023-05-15',
      'avatar': 'CR',
      'currentOrderId': null,
    },
    {
      'id': 'DRV002',
      'name': 'Ana Martínez',
      'phone': '+57 301 456 7890',
      'email': 'ana.martinez@email.com',
      'vehiclePlate': 'XYZ-789',
      'vehicleType': 'Furgón',
      'vehicleModel': 'Ford Transit 2021',
      'status': 'ocupado',
      'currentLocation': 'En tránsito a Buenaventura',
      'rating': 4.9,
      'totalDeliveries': 98,
      'licenseType': 'C1',
      'joinDate': '2023-08-20',
      'avatar': 'AM',
      'currentOrderId': 'PED001',
    },
    {
      'id': 'DRV003',
      'name': 'Miguel Torres',
      'phone': '+57 302 789 1234',
      'email': 'miguel.torres@email.com',
      'vehiclePlate': 'DEF-456',
      'vehicleType': 'Camioneta',
      'vehicleModel': 'Toyota Hilux 2022',
      'status': 'disponible',
      'currentLocation': 'Cali - Norte',
      'rating': 4.7,
      'totalDeliveries': 89,
      'licenseType': 'B2',
      'joinDate': '2023-09-10',
      'avatar': 'MT',
      'currentOrderId': null,
    },
    {
      'id': 'DRV004',
      'name': 'Laura Hernández',
      'phone': '+57 305 555 9876',
      'email': 'laura.hernandez@email.com',
      'vehiclePlate': 'GHI-789',
      'vehicleType': 'Furgón',
      'vehicleModel': 'Renault Master 2021',
      'status': 'inactivo',
      'currentLocation': 'Cali - Sur',
      'rating': 4.6,
      'totalDeliveries': 67,
      'licenseType': 'C1',
      'joinDate': '2023-07-05',
      'avatar': 'LH',
      'currentOrderId': null,
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

  // Layout para escritorio
  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1400),
          margin: const EdgeInsets.symmetric(horizontal: 60.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header administrativo compacto
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B35), Color(0xFFE55A2B)],
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
                      IconButton(
                        onPressed: () => context.go('/admin'),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24,
                        ),
                        tooltip: 'Volver al panel administrativo',
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.local_shipping_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Gestión de Conductores',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 28,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${_drivers.length} conductores registrados',
                              style: TextStyle(
                                fontSize: 16,
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

              // Contenido en dos columnas para desktop
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Columna izquierda: Filtros y búsqueda (30%)
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        _buildSearchAndFilters(true),
                        const SizedBox(height: 20),
                        _buildQuickStats(true),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),

                  // Columna derecha: Lista de conductores (70%)
                  Expanded(
                    flex: 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Lista de Conductores',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Grid de conductores en desktop (2 columnas)
                        _buildDriversGrid(true),
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

  // Layout original para móvil
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
                  colors: [Color(0xFFFF6B35), Color(0xFFE55A2B)],
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
                              Icons.local_shipping_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Gestión de Conductores',
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
                        '${_drivers.length} conductores registrados',
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
                  _buildSearchAndFilters(false),
                  const SizedBox(height: 24),
                  _buildQuickStats(false),
                  const SizedBox(height: 32),

                  const Text(
                    'Lista de Conductores',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildDriversGrid(false),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ]),
        ),
      ],
    );
  }

  Widget _buildDriversGrid(bool isDesktop) {
    if (isDesktop) {
      // Para desktop: Grid de 2 columnas
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.4, // Ajusta la proporción de las tarjetas
        ),
        itemCount: _drivers.length,
        itemBuilder: (context, index) {
          return _DriverCard(
            driver: _drivers[index],
            isDesktop: isDesktop,
            onViewProfile: () => _viewDriverProfile(_drivers[index]['id']),
            onAssignToOrder: () => _showOrderAssignmentDialog(_drivers[index]),
            onContactDriver: () => _contactDriver(_drivers[index]['phone']),
            onToggleStatus:
                () => _toggleDriverStatus(
                  _drivers[index]['id'],
                  _drivers[index]['name'],
                ),
          );
        },
      );
    } else {
      // Para móvil: Lista vertical
      return Column(
        children:
            _drivers
                .map(
                  (driver) => _DriverCard(
                    driver: driver,
                    isDesktop: isDesktop,
                    onViewProfile: () => _viewDriverProfile(driver['id']),
                    onAssignToOrder: () => _showOrderAssignmentDialog(driver),
                    onContactDriver: () => _contactDriver(driver['phone']),
                    onToggleStatus:
                        () => _toggleDriverStatus(driver['id'], driver['name']),
                  ),
                )
                .toList(),
      );
    }
  }

  Widget _buildSearchAndFilters(bool isDesktop) {
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
        padding: EdgeInsets.all(isDesktop ? 18.0 : 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isDesktop) ...[
              Text(
                'Búsqueda y Filtros',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 14),
            ],

            // Campo de búsqueda
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText:
                    isDesktop
                        ? 'Buscar conductor...'
                        : 'Buscar por nombre, placa o ubicación...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding: EdgeInsets.symmetric(
                  vertical: isDesktop ? 12.0 : 16.0,
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
                  borderSide: const BorderSide(
                    color: Color(0xFFFF6B35),
                    width: 2,
                  ),
                ),
              ),
            ),
            SizedBox(height: isDesktop ? 14 : 16),

            // Filtros
            Text(
              'Filtrar por:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A1A),
                fontSize: isDesktop ? 13 : 14,
              ),
            ),
            const SizedBox(height: 8),

            // Chips de filtro en columna para desktop
            if (isDesktop) ...[
              _FilterChip(
                label: 'Todos',
                isSelected: _selectedFilter == 'todos',
                onTap: () => setState(() => _selectedFilter = 'todos'),
              ),
              const SizedBox(height: 6),
              _FilterChip(
                label: 'Disponibles',
                isSelected: _selectedFilter == 'disponible',
                onTap: () => setState(() => _selectedFilter = 'disponible'),
              ),
              const SizedBox(height: 6),
              _FilterChip(
                label: 'Ocupados',
                isSelected: _selectedFilter == 'ocupado',
                onTap: () => setState(() => _selectedFilter = 'ocupado'),
              ),
              const SizedBox(height: 6),
              _FilterChip(
                label: 'Camiones',
                isSelected: _selectedFilter == 'camion',
                onTap: () => setState(() => _selectedFilter = 'camion'),
              ),
              const SizedBox(height: 6),
              _FilterChip(
                label: 'Furgones',
                isSelected: _selectedFilter == 'furgon',
                onTap: () => setState(() => _selectedFilter = 'furgon'),
              ),
            ] else ...[
              // Para móvil: Scroll horizontal
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'Todos',
                      isSelected: _selectedFilter == 'todos',
                      onTap: () => setState(() => _selectedFilter = 'todos'),
                    ),
                    _FilterChip(
                      label: 'Disponibles',
                      isSelected: _selectedFilter == 'disponible',
                      onTap:
                          () => setState(() => _selectedFilter = 'disponible'),
                    ),
                    _FilterChip(
                      label: 'Ocupados',
                      isSelected: _selectedFilter == 'ocupado',
                      onTap: () => setState(() => _selectedFilter = 'ocupado'),
                    ),
                    _FilterChip(
                      label: 'Camiones',
                      isSelected: _selectedFilter == 'camion',
                      onTap: () => setState(() => _selectedFilter = 'camion'),
                    ),
                    _FilterChip(
                      label: 'Furgones',
                      isSelected: _selectedFilter == 'furgon',
                      onTap: () => setState(() => _selectedFilter = 'furgon'),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(bool isDesktop) {
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
        padding: EdgeInsets.all(isDesktop ? 18.0 : 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isDesktop) ...[
              Text(
                'Estadísticas',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 14),
            ],

            // Stats en columna para desktop, en fila para móvil
            if (isDesktop) ...[
              _StatItem(
                value: '${_drivers.length}',
                label: 'Total Conductores',
                icon: Icons.people,
                color: const Color(0xFFFF6B35),
                isDesktop: isDesktop,
              ),
              const SizedBox(height: 12),
              _StatItem(
                value:
                    '${_drivers.where((d) => d['status'] == 'disponible').length}',
                label: 'Disponibles',
                icon: Icons.check_circle,
                color: const Color(0xFF28A745),
                isDesktop: isDesktop,
              ),
              const SizedBox(height: 12),
              _StatItem(
                value:
                    '${_drivers.where((d) => d['status'] == 'ocupado').length}',
                label: 'En Servicio',
                icon: Icons.local_shipping,
                color: const Color(0xFF007BFF),
                isDesktop: isDesktop,
              ),
              const SizedBox(height: 12),
              _StatItem(
                value: '4.75',
                label: 'Rating Promedio',
                icon: Icons.star,
                color: const Color(0xFFFFC107),
                isDesktop: isDesktop,
              ),
            ] else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatItem(
                    value: '${_drivers.length}',
                    label: 'Total Conductores',
                    icon: Icons.people,
                    color: const Color(0xFFFF6B35),
                    isDesktop: isDesktop,
                  ),
                  _StatItem(
                    value:
                        '${_drivers.where((d) => d['status'] == 'disponible').length}',
                    label: 'Disponibles',
                    icon: Icons.check_circle,
                    color: const Color(0xFF28A745),
                    isDesktop: isDesktop,
                  ),
                  _StatItem(
                    value:
                        '${_drivers.where((d) => d['status'] == 'ocupado').length}',
                    label: 'En Servicio',
                    icon: Icons.local_shipping,
                    color: const Color(0xFF007BFF),
                    isDesktop: isDesktop,
                  ),
                  _StatItem(
                    value: '4.75',
                    label: 'Rating Promedio',
                    icon: Icons.star,
                    color: const Color(0xFFFFC107),
                    isDesktop: isDesktop,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Funciones de acciones
  void _viewDriverProfile(String driverId) {
    _showSuccessMessage('Viendo perfil del conductor $driverId');
  }

  void _showOrderAssignmentDialog(Map<String, dynamic> driver) {
    if (driver['status'] != 'disponible') {
      _showErrorMessage(
        'El conductor no está disponible para nuevas asignaciones',
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text('Asignar Pedido a ${driver['name']}'),
          content: const Text(
            '¿Desea asignar un pedido pendiente a este conductor?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/admin/orders');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35),
                foregroundColor: Colors.white,
              ),
              child: const Text('Seleccionar Pedido'),
            ),
          ],
        );
      },
    );
  }

  void _contactDriver(String phone) {
    _showSuccessMessage('Llamando a $phone...');
  }

  void _toggleDriverStatus(String driverId, String driverName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Cambiar Estado'),
          content: Text('¿Cambiar el estado de disponibilidad de $driverName?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showSuccessMessage('Estado de $driverName actualizado');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35),
                foregroundColor: Colors.white,
              ),
              child: const Text('Cambiar'),
            ),
          ],
        );
      },
    );
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

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFFDC3545),
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
      width: MediaQuery.of(context).size.width > 768 ? double.infinity : null,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFF6B35) : Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? const Color(0xFFFF6B35) : Colors.grey[300]!,
            ),
          ),
          child: Text(
            label,
            textAlign:
                MediaQuery.of(context).size.width > 768
                    ? TextAlign.center
                    : TextAlign.left,
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
  final bool isDesktop;

  const _StatItem({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
    this.isDesktop = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isDesktop) {
      return Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
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

// Widget para cada tarjeta de conductor
class _DriverCard extends StatelessWidget {
  final Map<String, dynamic> driver;
  final bool isDesktop;
  final VoidCallback onViewProfile;
  final VoidCallback onAssignToOrder;
  final VoidCallback onContactDriver;
  final VoidCallback onToggleStatus;

  const _DriverCard({
    required this.driver,
    required this.isDesktop,
    required this.onViewProfile,
    required this.onAssignToOrder,
    required this.onContactDriver,
    required this.onToggleStatus,
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case 'disponible':
        return const Color(0xFF28A745);
      case 'ocupado':
        return const Color(0xFF007BFF);
      case 'inactivo':
        return const Color(0xFFDC3545);
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'disponible':
        return 'DISPONIBLE';
      case 'ocupado':
        return 'OCUPADO';
      case 'inactivo':
        return 'INACTIVO';
      default:
        return 'DESCONOCIDO';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(driver['status']);
    final isAvailable = driver['status'] == 'disponible';

    return Container(
      margin: EdgeInsets.only(bottom: isDesktop ? 0 : 16),
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
        padding: EdgeInsets.all(isDesktop ? 16.0 : 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar del conductor
                Container(
                  width: isDesktop ? 48 : 56,
                  height: isDesktop ? 48 : 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [statusColor, statusColor.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(isDesktop ? 14 : 16),
                  ),
                  child: Center(
                    child: Text(
                      driver['avatar'],
                      style: TextStyle(
                        fontSize: isDesktop ? 16 : 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: isDesktop ? 12 : 16),

                // Información del conductor
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              driver['name'],
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: isDesktop ? 14 : 16,
                                color: const Color(0xFF1A1A1A),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Estado
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isDesktop ? 6 : 8,
                              vertical: isDesktop ? 2 : 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _getStatusText(driver['status']),
                              style: TextStyle(
                                fontSize: isDesktop ? 8 : 10,
                                fontWeight: FontWeight.w600,
                                color: statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isDesktop ? 2 : 4),
                      Text(
                        driver['phone'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: isDesktop ? 12 : 14,
                        ),
                      ),
                      SizedBox(height: isDesktop ? 2 : 4),
                      Text(
                        '${driver['vehicleType']} • ${driver['vehiclePlate']}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: isDesktop ? 12 : 14,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: isDesktop ? 6 : 8),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber[600],
                            size: isDesktop ? 14 : 16,
                          ),
                          SizedBox(width: isDesktop ? 2 : 4),
                          Text(
                            '${driver['rating']}',
                            style: TextStyle(
                              fontSize: isDesktop ? 10 : 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A1A1A),
                            ),
                          ),
                          SizedBox(width: isDesktop ? 12 : 16),
                          Icon(
                            Icons.delivery_dining,
                            color: Colors.grey[500],
                            size: isDesktop ? 14 : 16,
                          ),
                          SizedBox(width: isDesktop ? 2 : 4),
                          Expanded(
                            child: Text(
                              '${driver['totalDeliveries']} entregas',
                              style: TextStyle(
                                fontSize: isDesktop ? 10 : 12,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ubicación actual',
                              style: TextStyle(
                                fontSize: isDesktop ? 10 : 12,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              driver['currentLocation'],
                              style: TextStyle(
                                fontSize: isDesktop ? 11 : 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1A1A1A),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Licencia',
                            style: TextStyle(
                              fontSize: isDesktop ? 10 : 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            driver['licenseType'],
                            style: TextStyle(
                              fontSize: isDesktop ? 11 : 13,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A1A1A),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: isDesktop ? 6 : 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          driver['vehicleModel'],
                          style: TextStyle(
                            fontSize: isDesktop ? 10 : 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (driver['currentOrderId'] != null)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isDesktop ? 6 : 8,
                            vertical: isDesktop ? 1 : 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF007BFF).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Pedido: ${driver['currentOrderId']}',
                            style: TextStyle(
                              fontSize: isDesktop ? 8 : 10,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF007BFF),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: isDesktop ? 12 : 16),

            // Botones de acción
            if (isDesktop) ...[
              // Para desktop: Botones más compactos en columna
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        profile(context, driver['id']);
                      },
                      icon: const Icon(Icons.person_outlined, size: 14),
                      label: const Text(
                        'Ver Perfil',
                        style: TextStyle(fontSize: 12),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF007BFF),
                        side: const BorderSide(color: Color(0xFF007BFF)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 32,
                          child: OutlinedButton.icon(
                            onPressed: onContactDriver,
                            icon: const Icon(Icons.call, size: 14),
                            label: const Text(
                              'Llamar',
                              style: TextStyle(fontSize: 12),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF28A745),
                              side: const BorderSide(color: Color(0xFF28A745)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: SizedBox(
                          height: 32,
                          child: OutlinedButton.icon(
                            onPressed:
                                isAvailable ? onAssignToOrder : onToggleStatus,
                            icon: Icon(
                              isAvailable ? Icons.assignment : Icons.refresh,
                              size: 14,
                            ),
                            label: Text(
                              isAvailable ? 'Asignar' : 'Estado',
                              style: const TextStyle(fontSize: 12),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor:
                                  isAvailable
                                      ? const Color(0xFFFF6B35)
                                      : const Color(0xFFFFC107),
                              side: BorderSide(
                                color:
                                    isAvailable
                                        ? const Color(0xFFFF6B35)
                                        : const Color(0xFFFFC107),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ] else ...[
              // Para móvil: Layout original en fila
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        profile(context, driver['id']);
                      },
                      icon: const Icon(Icons.person_outlined, size: 18),
                      label: const Text('Ver Perfil'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF007BFF),
                        side: const BorderSide(color: Color(0xFF007BFF)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onContactDriver,
                      icon: const Icon(Icons.call, size: 18),
                      label: const Text('Llamar'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF28A745),
                        side: const BorderSide(color: Color(0xFF28A745)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (isAvailable)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onAssignToOrder,
                        icon: const Icon(Icons.assignment, size: 18),
                        label: const Text('Asignar'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFFF6B35),
                          side: const BorderSide(color: Color(0xFFFF6B35)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  if (!isAvailable)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onToggleStatus,
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('Estado'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFFFC107),
                          side: const BorderSide(color: Color(0xFFFFC107)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Función para navegar al perfil del conductor
void profile(BuildContext context, String driverId) {
  context.go('/admin/drivers/profile/$driverId');
}
 