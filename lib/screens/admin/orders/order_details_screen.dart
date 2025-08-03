import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String orderId;
  const OrderDetailsScreen({super.key, required this.orderId});
  static const String name = 'OrderDetailsScreen';

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Datos de ejemplo del pedido (normalmente vendran de una API)
  late Map<String, dynamic> _orderDetails;

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

    // Simular datos del pedido basado en el ID
    _orderDetails = widget.orderId == 'PED001' ? {
      'id': 'PED001',
      'trackingCode': 'TRK001BV',
      'clientName': 'María González',
      'clientPhone': '+57 301 987 6543',
      'clientEmail': 'maria.gonzalez@email.com',
      'origin': 'Cali - Centro',
      'originAddress': 'Carrera 5 #10-50, Centro, Cali',
      'destination': 'Buenaventura - Terminal',
      'destinationAddress': 'Terminal de Transportes, Buenaventura',
      'status': 'en_transito',
      'priority': 'alta',
      'estimatedDelivery': '2024-08-02 16:30',
      'createdAt': '2024-08-01 08:00',
      'driverName': 'Carlos Rodríguez',
      'driverPhone': '+57 300 123 4567',
      'vehiclePlate': 'ABC-123',
      'packageCount': 3,
      'totalWeight': '15.5 kg',
      'specialInstructions': 'Entregar en horario de oficina. Producto frágil.',
      'timeline': [
        {
          'status': 'creado',
          'timestamp': '2024-08-01 08:00',
          'description': 'Pedido creado y confirmado',
          'location': 'Cali - Centro',
        },
        {
          'status': 'recogido',
          'timestamp': '2024-08-01 10:30',
          'description': 'Paquete recogido por el conductor',
          'location': 'Cali - Centro',
        },
        {
          'status': 'en_transito',
          'timestamp': '2024-08-01 11:00',
          'description': 'En camino a Buenaventura',
          'location': 'Autopista Cali-Buenaventura',
        },
      ],
    } : {
      'id': 'PED002',
      'trackingCode': 'TRK002BV',
      'clientName': 'Roberto Silva',
      'clientPhone': '+57 300 456 7890',
      'clientEmail': 'roberto.silva@email.com',
      'origin': 'Cali - Norte',
      'originAddress': 'Carrera 15 #85-20, Norte, Cali',
      'destination': 'Buenaventura - Puerto',
      'destinationAddress': 'Puerto de Buenaventura, Zona Portuaria',
      'status': 'pendiente',
      'priority': 'media',
      'estimatedDelivery': '2024-08-03 10:00',
      'createdAt': '2024-08-02 09:15',
      'driverName': null,
      'driverPhone': null,
      'vehiclePlate': null,
      'packageCount': 1,
      'totalWeight': '8.0 kg',
      'specialInstructions': 'Coordinar entrega con seguridad del puerto.',
      'timeline': [
        {
          'status': 'creado',
          'timestamp': '2024-08-02 09:15',
          'description': 'Pedido creado, esperando asignación de conductor',
          'location': 'Cali - Norte',
        },
      ],
    };
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
            // App Bar personalizado
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                onPressed: () => context.go('/admin/orders'),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              actions: [
                IconButton(
                  onPressed: _shareOrderDetails,
                  icon: const Icon(Icons.share, color: Colors.white),
                  tooltip: 'Compartir detalles',
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF007BFF), Color(0xFF0056B3)],
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
                                  Icons.receipt_long,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Detalles del Pedido',
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
                            _orderDetails['trackingCode'],
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

            // Contenido principal
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Estado y acciones rápidas
                      _buildStatusCard(),
                      const SizedBox(height: 24),

                      // Información del cliente
                      _buildClientInfoCard(),
                      const SizedBox(height: 24),

                      // Información del envío
                      _buildShippingInfoCard(),
                      const SizedBox(height: 24),

                      // Información del conductor (si está asignado)
                      if (_orderDetails['driverName'] != null)
                        _buildDriverInfoCard(),
                      if (_orderDetails['driverName'] != null)
                        const SizedBox(height: 24),

                      // Timeline del pedido
                      _buildTimelineCard(),
                      const SizedBox(height: 24),

                      // Botones de acción
                      _buildActionButtons(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    final statusColor = _getStatusColor(_orderDetails['status']);
    final priorityColor = _getPriorityColor(_orderDetails['priority']);

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
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Estado del Pedido',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: priorityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Prioridad ${_orderDetails['priority']}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: priorityColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    _getStatusIcon(_orderDetails['status']),
                    color: statusColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getStatusText(_orderDetails['status']),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Entrega estimada: ${_orderDetails['estimatedDelivery']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClientInfoCard() {
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
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Información del Cliente',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 16),
            _InfoRow(
              icon: Icons.person,
              label: 'Nombre',
              value: _orderDetails['clientName'],
            ),
            _InfoRow(
              icon: Icons.phone,
              label: 'Teléfono',
              value: _orderDetails['clientPhone'],
            ),
            _InfoRow(
              icon: Icons.email,
              label: 'Email',
              value: _orderDetails['clientEmail'],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingInfoCard() {
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
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Información del Envío',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 16),
            _InfoRow(
              icon: Icons.location_on,
              label: 'Origen',
              value: _orderDetails['originAddress'],
            ),
            _InfoRow(
              icon: Icons.location_on_outlined,
              label: 'Destino',
              value: _orderDetails['destinationAddress'],
            ),
            _InfoRow(
              icon: Icons.inventory_2,
              label: 'Paquetes',
              value: '${_orderDetails['packageCount']} paquete(s)',
            ),
            _InfoRow(
              icon: Icons.scale,
              label: 'Peso total',
              value: _orderDetails['totalWeight'],
            ),
            if (_orderDetails['specialInstructions'].isNotEmpty)
              _InfoRow(
                icon: Icons.note,
                label: 'Instrucciones',
                value: _orderDetails['specialInstructions'],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverInfoCard() {
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
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Conductor Asignado',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF28A745).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'ASIGNADO',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF28A745),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _InfoRow(
              icon: Icons.person,
              label: 'Conductor',
              value: _orderDetails['driverName'],
            ),
            _InfoRow(
              icon: Icons.phone,
              label: 'Teléfono',
              value: _orderDetails['driverPhone'],
            ),
            _InfoRow(
              icon: Icons.directions_car,
              label: 'Vehículo',
              value: _orderDetails['vehiclePlate'],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineCard() {
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
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Historial del Pedido',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 16),
            ...(_orderDetails['timeline'] as List).map((event) => 
              _TimelineItem(
                timestamp: event['timestamp'],
                description: event['description'],
                location: event['location'],
                isLast: (_orderDetails['timeline'] as List).last == event,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        if (_orderDetails['driverName'] == null)
          Container(
            width: double.infinity,
            height: 56,
            margin: const EdgeInsets.only(bottom: 12),
            child: ElevatedButton.icon(
              onPressed: () => context.go('/admin/drivers/assign/${widget.orderId}'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF28A745),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.person_add),
              label: const Text(
                'Asignar Conductor',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        Container(
          width: double.infinity,
          height: 56,
          margin: const EdgeInsets.only(bottom: 12),
          child: ElevatedButton.icon(
            onPressed: _updateOrderStatus,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007BFF),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.update),
            label: const Text(
              'Actualizar Estado',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _contactClient,
                icon: const Icon(Icons.call, size: 18),
                label: const Text('Contactar Cliente'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF28A745),
                  side: const BorderSide(color: Color(0xFF28A745)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _trackLocation,
                icon: const Icon(Icons.location_on, size: 18),
                label: const Text('Rastrear Ubicación'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF007BFF),
                  side: const BorderSide(color: Color(0xFF007BFF)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Funciones auxiliares
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

  String _getStatusText(String status) {
    switch (status) {
      case 'pendiente':
        return 'Pendiente de asignación';
      case 'en_transito':
        return 'En tránsito a destino';
      case 'entregado':
        return 'Entregado exitosamente';
      case 'cancelado':
        return 'Pedido cancelado';
      default:
        return 'Estado desconocido';
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pendiente':
        return Icons.pending;
      case 'en_transito':
        return Icons.local_shipping;
      case 'entregado':
        return Icons.check_circle;
      case 'cancelado':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  // Funciones de acciones
  void _shareOrderDetails() {
    _showSuccessMessage('Detalles del pedido compartidos');
  }

  void _updateOrderStatus() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Actualizar Estado'),
          content: const Text('¿Actualizar el estado de este pedido?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showSuccessMessage('Estado del pedido actualizado');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007BFF),
                foregroundColor: Colors.white,
              ),
              child: const Text('Actualizar'),
            ),
          ],
        );
      },
    );
  }

  void _contactClient() {
    _showSuccessMessage('Iniciando llamada al cliente...');
  }

  void _trackLocation() {
    _showSuccessMessage('Abriendo rastreador de ubicación...');
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

// Widget para mostrar información en filas
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF007BFF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF007BFF), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget para elementos del timeline
class _TimelineItem extends StatelessWidget {
  final String timestamp;
  final String description;
  final String location;
  final bool isLast;

  const _TimelineItem({
    required this.timestamp,
    required this.description,
    required this.location,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Color(0xFF007BFF),
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 60,
                  color: Colors.grey[300],
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    location,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timestamp,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}