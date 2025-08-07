import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderManagementScreen extends StatefulWidget {
  const OrderManagementScreen({super.key});
  static const String name = 'OrderManagementScreen';

  @override
  State<OrderManagementScreen> createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'todos';

  // Datos de ejemplo de pedidos
  final List<Map<String, dynamic>> _orders = [
    {
      'id': 'PED001',
      'clientName': 'María González',
      'clientPhone': '+57 301 987 6543',
      'origin': 'Cali - Centro',
      'destination': 'Buenaventura - Terminal',
      'status': 'en_transito',
      'priority': 'alta',
      'estimatedDelivery': '2024-08-02 16:30',
      'createdAt': '2024-08-01 08:00',
      'driverName': 'Carlos Rodríguez',
      'trackingCode': 'TRK001BV',
      'packageCount': 3,
      'totalWeight': '15.5 kg',
    },
    {
      'id': 'PED002',
      'clientName': 'Roberto Silva',
      'clientPhone': '+57 300 456 7890',
      'origin': 'Cali - Norte',
      'destination': 'Buenaventura - Puerto',
      'status': 'pendiente',
      'priority': 'media',
      'estimatedDelivery': '2024-08-03 10:00',
      'createdAt': '2024-08-02 09:15',
      'driverName': null,
      'trackingCode': 'TRK002BV',
      'packageCount': 1,
      'totalWeight': '8.0 kg',
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

  // Layout compacto y centrado para escritorio
  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1100), // Ancho máximo para escritorio
          margin: const EdgeInsets.symmetric(horizontal: 40.0), // Márgenes laterales
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header administrativo compacto
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF28A745), Color(0xFF20A13A)],
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
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                        tooltip: 'Volver al panel',
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.inventory_2_outlined,
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
                              'Gestión de Pedidos',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 28,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${_orders.length} pedidos registrados',
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

              // Búsqueda y estadísticas en una fila
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Búsqueda y filtros (lado izquierdo)
                  Expanded(
                    flex: 2,
                    child: _buildSearchAndFilters(true),
                  ),
                  const SizedBox(width: 20),
                  // Estadísticas rápidas (lado derecho)
                  Expanded(
                    flex: 1,
                    child: _buildQuickStats(true),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),

              // Botón crear pedido compacto
              _buildCreateOrderButton(true),
              const SizedBox(height: 24),

              // Lista de pedidos en grid para escritorio
              const Text(
                'Lista de Pedidos',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 16),

              // Grid de pedidos para escritorio
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.4, // Proporción más ancha
                ),
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  final order = _orders[index];
                  return _OrderCard(
                    order: order,
                    onViewDetails: () => _viewOrderDetails(order['id']),
                    onAssignDriver: () => _assignDriver(order['id']),
                    onUpdateStatus: () => _updateOrderStatus(order['id'], order['clientName']),
                    isDesktop: true,
                  );
                },
              ),

              const SizedBox(height: 40), // Espacio final
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
                  colors: [Color(0xFF28A745), Color(0xFF20A13A)],
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
                              Icons.inventory_2_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Gestión de Pedidos',
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
                        '${_orders.length} pedidos registrados',
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
                  _buildSearchAndFilters(false),
                  const SizedBox(height: 24),

                  // Estadísticas rápidas
                  _buildQuickStats(false),
                  const SizedBox(height: 32),

                  // Botón para crear pedido
                  _buildCreateOrderButton(false),
                  const SizedBox(height: 24),

                  // Lista de pedidos
                  const Text(
                    'Lista de Pedidos',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 16),

                  ..._orders.map((order) => _OrderCard(
                    order: order,
                    onViewDetails: () => _viewOrderDetails(order['id']),
                    onAssignDriver: () => _assignDriver(order['id']),
                    onUpdateStatus: () => _updateOrderStatus(order['id'], order['clientName']),
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
        padding: EdgeInsets.all(isDesktop ? 16.0 : 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isDesktop) ...[
              const Text(
                'Buscar y Filtrar',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 12),
            ],
            // Campo de búsqueda
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por código, cliente o destino...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding: EdgeInsets.symmetric(
                  vertical: isDesktop ? 12.0 : 16.0,
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
                  borderSide: const BorderSide(color: Color(0xFF28A745), width: 2),
                ),
              ),
            ),
            SizedBox(height: isDesktop ? 12 : 16),

            // Filtros
            Row(
              children: [
                Text(
                  'Filtrar por:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A1A),
                    fontSize: isDesktop ? 13 : 14,
                  ),
                ),
                SizedBox(width: isDesktop ? 12 : 16),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterChip(
                          label: 'Todos',
                          isSelected: _selectedFilter == 'todos',
                          onTap: () => setState(() => _selectedFilter = 'todos'),
                          isDesktop: isDesktop,
                        ),
                        _FilterChip(
                          label: 'Pendiente',
                          isSelected: _selectedFilter == 'pendiente',
                          onTap: () => setState(() => _selectedFilter = 'pendiente'),
                          isDesktop: isDesktop,
                        ),
                        _FilterChip(
                          label: 'En Tránsito',
                          isSelected: _selectedFilter == 'en_transito',
                          onTap: () => setState(() => _selectedFilter = 'en_transito'),
                          isDesktop: isDesktop,
                        ),
                        _FilterChip(
                          label: 'Entregado',
                          isSelected: _selectedFilter == 'entregado',
                          onTap: () => setState(() => _selectedFilter = 'entregado'),
                          isDesktop: isDesktop,
                        ),
                        _FilterChip(
                          label: 'Alta Prioridad',
                          isSelected: _selectedFilter == 'alta',
                          onTap: () => setState(() => _selectedFilter = 'alta'),
                          isDesktop: isDesktop,
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
        padding: EdgeInsets.all(isDesktop ? 16.0 : 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isDesktop) ...[
              const Text(
                'Estadísticas',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 12),
            ],
            isDesktop ? _buildDesktopStatsGrid() : _buildMobileStatsRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopStatsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatItem(
                value: '2',
                label: 'Total Pedidos',
                icon: Icons.inventory_2,
                color: const Color(0xFF28A745),
                isDesktop: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatItem(
                value: '1',
                label: 'En Tránsito',
                icon: Icons.local_shipping,
                color: const Color(0xFF007BFF),
                isDesktop: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatItem(
                value: '1',
                label: 'Pendientes',
                icon: Icons.pending,
                color: const Color(0xFFFFC107),
                isDesktop: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatItem(
                value: '0',
                label: 'Entregados',
                icon: Icons.check_circle,
                color: const Color(0xFF20C997),
                isDesktop: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _StatItem(
          value: '2',
          label: 'Total Pedidos',
          icon: Icons.inventory_2,
          color: const Color(0xFF28A745),
          isDesktop: false,
        ),
        _StatItem(
          value: '1',
          label: 'En Tránsito',
          icon: Icons.local_shipping,
          color: const Color(0xFF007BFF),
          isDesktop: false,
        ),
        _StatItem(
          value: '1',
          label: 'Pendientes',
          icon: Icons.pending,
          color: const Color(0xFFFFC107),
          isDesktop: false,
        ),
        _StatItem(
          value: '0',
          label: 'Entregados',
          icon: Icons.check_circle,
          color: const Color(0xFF20C997),
          isDesktop: false,
        ),
      ],
    );
  }

  Widget _buildCreateOrderButton(bool isDesktop) {
    return Container(
      width: double.infinity,
      height: isDesktop ? 48 : 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF007BFF), Color(0xFF0056B3)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF007BFF).withOpacity(0.3),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () => context.go('/admin/orders/create'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        icon: Icon(Icons.add, color: Colors.white, size: isDesktop ? 20 : 24),
        label: Text(
          'Crear Nuevo Pedido',
          style: TextStyle(
            fontSize: isDesktop ? 14 : 16,
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  // Funciones de acciones
  void _viewOrderDetails(String orderId) {
    context.go('/admin/orders/details/$orderId');
  }

  void _assignDriver(String orderId) {
    context.go('/admin/drivers/assign/$orderId');
  }

  void _updateOrderStatus(String orderId, String clientName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Actualizar Estado'),
          content: Text('¿Actualizar el estado del pedido de $clientName?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showSuccessMessage('Estado del pedido actualizado correctamente');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF28A745),
                foregroundColor: Colors.white,
              ),
              child: const Text('Actualizar'),
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
}

// Widget para los chips de filtro
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDesktop;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 12 : 16, 
            vertical: isDesktop ? 6 : 8
          ),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF28A745) : Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? const Color(0xFF28A745) : Colors.grey[300]!,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[700],
              fontWeight: FontWeight.w500,
              fontSize: isDesktop ? 12 : 14,
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
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 8 : 0),
      decoration: isDesktop ? BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ) : null,
      child: Column(
        children: [
          Container(
            width: isDesktop ? 36 : 48,
            height: isDesktop ? 36 : 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon, 
              color: color, 
              size: isDesktop ? 20 : 24
            ),
          ),
          SizedBox(height: isDesktop ? 6 : 8),
          Text(
            value,
            style: TextStyle(
              fontSize: isDesktop ? 16 : 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: isDesktop ? 2 : 4),
          Text(
            label,
            style: TextStyle(
              fontSize: isDesktop ? 10 : 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Widget para cada tarjeta de pedido
class _OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final VoidCallback onViewDetails;
  final VoidCallback onAssignDriver;
  final VoidCallback onUpdateStatus;
  final bool isDesktop;

  const _OrderCard({
    required this.order,
    required this.onViewDetails,
    required this.onAssignDriver,
    required this.onUpdateStatus,
    required this.isDesktop,
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pendiente':
        return const Color(0xFFFFC107);
      case 'en_transito':
        return const Color(0xFF007BFF);
      case 'entregado':
        return const Color(0xFF28A745);
      case 'cancelado':
        return const Color(0xFFDC3545);
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pendiente':
        return 'PENDIENTE';
      case 'en_transito':
        return 'EN TRÁNSITO';
      case 'entregado':
        return 'ENTREGADO';
      case 'cancelado':
        return 'CANCELADO';
      default:
        return 'DESCONOCIDO';
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'alta':
        return const Color(0xFFDC3545);
      case 'media':
        return const Color(0xFFFFC107);
      case 'baja':
        return const Color(0xFF28A745);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(order['status']);
    final priorityColor = _getPriorityColor(order['priority']);
    
    return Container(
      margin: EdgeInsets.only(bottom: isDesktop ? 150 : 16),
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
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icono del pedido
                Container(
                  width: isDesktop ? 48 : 56,
                  height: isDesktop ? 48 : 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        statusColor,
                        statusColor.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.inventory_2,
                      color: Colors.white,
                      size: isDesktop ? 20 : 24,
                    ),
                  ),
                ),
                SizedBox(width: isDesktop ? 12 : 16),

                // Información del pedido
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              order['clientName'],
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: isDesktop ? 14 : 16,
                                color: const Color(0xFF1A1A1A),
                              ),
                            ),
                          ),
                          // Estado
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isDesktop ? 6 : 8,
                              vertical: isDesktop ? 3 : 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _getStatusText(order['status']),
                              style: TextStyle(
                                fontSize: isDesktop ? 9 : 10,
                                fontWeight: FontWeight.w600,
                                color: statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isDesktop ? 3 : 4),
                      Text(
                        '${order['origin']} → ${order['destination']}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: isDesktop ? 12 : 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: isDesktop ? 6 : 8),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isDesktop ? 6 : 8,
                              vertical: isDesktop ? 2 : 2,
                            ),
                            decoration: BoxDecoration(
                              color: priorityColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              order['priority'].toUpperCase(),
                              style: TextStyle(
                                fontSize: isDesktop ? 9 : 10,
                                fontWeight: FontWeight.w600,
                                color: priorityColor,
                              ),
                            ),
                          ),
                          SizedBox(width: isDesktop ? 6 : 8),
                          Text(
                            order['trackingCode'],
                            style: TextStyle(
                              fontSize: isDesktop ? 10 : 12,
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
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Conductor',
                            style: TextStyle(
                              fontSize: isDesktop ? 10 : 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            order['driverName'] ?? 'Sin asignar',
                            style: TextStyle(
                              fontSize: isDesktop ? 11 : 13,
                              fontWeight: FontWeight.w600,
                              color: order['driverName'] != null 
                                ? const Color(0xFF1A1A1A)
                                : Colors.red[400],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Entrega estimada',
                            style: TextStyle(
                              fontSize: isDesktop ? 10 : 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            order['estimatedDelivery'],
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
                      Text(
                        '${order['packageCount']} paquete(s) • ${order['totalWeight']}',
                        style: TextStyle(
                          fontSize: isDesktop ? 10 : 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'ID: ${order['id']}',
                        style: TextStyle(
                          fontSize: isDesktop ? 10 : 12,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
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
                    onPressed: onViewDetails,
                    icon: Icon(
                      Icons.visibility_outlined, 
                      size: isDesktop ? 16 : 18
                    ),
                    label: Text(
                      'Ver Detalles',
                      style: TextStyle(
                        fontSize: isDesktop ? 12 : 14,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF007BFF),
                      side: const BorderSide(color: Color(0xFF007BFF)),
                      padding: EdgeInsets.symmetric(
                        vertical: isDesktop ? 8 : 12,
                        horizontal: isDesktop ? 12 : 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: isDesktop ? 8 : 12),
                if (order['driverName'] == null)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onAssignDriver,
                      icon: Icon(
                        Icons.person_add, 
                        size: isDesktop ? 16 : 18
                      ),
                      label: Text(
                        'Asignar',
                        style: TextStyle(
                          fontSize: isDesktop ? 12 : 14,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF28A745),
                        side: const BorderSide(color: Color(0xFF28A745)),
                        padding: EdgeInsets.symmetric(
                          vertical: isDesktop ? 8 : 12,
                          horizontal: isDesktop ? 12 : 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                if (order['driverName'] != null)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onUpdateStatus,
                      icon: Icon(
                        Icons.update, 
                        size: isDesktop ? 16 : 18
                      ),
                      label: Text(
                        'Actualizar',
                        style: TextStyle(
                          fontSize: isDesktop ? 12 : 14,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFFFC107),
                        side: const BorderSide(color: Color(0xFFFFC107)),
                        padding: EdgeInsets.symmetric(
                          vertical: isDesktop ? 8 : 12,
                          horizontal: isDesktop ? 12 : 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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
}