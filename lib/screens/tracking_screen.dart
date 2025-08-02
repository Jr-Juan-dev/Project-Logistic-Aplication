// lib/screens/tracking_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:topax/screens/qr_scanner_screen.dart';

// Enum para representar el flujo fijo del paquete. Es robusto y evita errores de tipeo.
enum PackageStatus {
  receivedInCali,
  inWarehouse,
  inTransitToBuenaventura,
  arrivedInBuenaventura,
  outForDelivery,
  delivered,
}

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});
  static const String name = 'TrackingScreen';

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen>
    with TickerProviderStateMixin {
  final TextEditingController _trackingIdController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Map<String, dynamic>? _packageData;
  bool _isLoading = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _trackingIdController.dispose();
    _focusNode.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  // Simula la búsqueda en el backend.
  Future<void> _trackPackage() async {
    final trackingId = _trackingIdController.text;
    if (trackingId.isEmpty) return;

    setState(() {
      _isLoading = true;
      _packageData = null;
    });

    await Future.delayed(const Duration(milliseconds: 750));

    // Datos de ejemplo. Aquí conectarías tu API.
    if (trackingId.toUpperCase().contains('1Z999')) {
      _packageData = {
        'id': '1Z999AA1234567890',
        'status':
            PackageStatus
                .inTransitToBuenaventura, // CAMBIA ESTE VALOR PARA PROBAR DIFERENTES ESTADOS
      };
    } else {
      _packageData = null;
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _scanAndTrack() async {
    final result = await context.pushNamed<String>(QRScannerScreen.name);
    if (mounted && result != null && result.isNotEmpty) {
      _trackingIdController.text = result;
      _trackPackage();
    }
  }

  void _clearSearch() {
    _trackingIdController.clear();
    _focusNode.unfocus();
    setState(() {
      _packageData = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        title: Text(
          _packageData == null ? 'Seguimiento de Envíos' : 'Estado del Paquete',
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey[800],
        elevation: 0,
        shadowColor: Colors.transparent,
        leading:
            _packageData != null
                ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _clearSearch,
                )
                : null,
      ),
      body: _packageData != null ? _buildResultsView() : _buildSearchView(),
    );
  }

  Widget _buildSearchView() {
    const Color primaryBlue = Color(0xFF007BFF);
    const Color accentGreen = Color(0xFF28A745);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          children: [
            // Ilustración principal
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          primaryBlue.withOpacity(0.1),
                          primaryBlue.withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Icon(
                      Icons.track_changes,
                      size: 60,
                      color: primaryBlue,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            // Título y subtítulo
            const Text(
              'Rastrear Envío',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Ingresa el número de guía o escanea el código QR para conocer el estado del paquete en tiempo real.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),

            const SizedBox(height: 48),

            // Contenedor principal de búsqueda
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    offset: const Offset(0, 4),
                    blurRadius: 20,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Campo de búsqueda mejorado
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.confirmation_number_outlined,
                            size: 20,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Número de Guía',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              offset: const Offset(0, 2),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _trackingIdController,
                          focusNode: _focusNode,
                          decoration: InputDecoration(
                            hintText: 'Ej: 1Z999AA1234567890',
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 16,
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 18.0,
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
                              borderSide: const BorderSide(
                                color: primaryBlue,
                                width: 2,
                              ),
                            ),
                            suffixIcon:
                                _isLoading
                                    ? Container(
                                      width: 20,
                                      height: 20,
                                      padding: const EdgeInsets.all(12.0),
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              primaryBlue,
                                            ),
                                      ),
                                    )
                                    : _trackingIdController.text.isNotEmpty
                                    ? IconButton(
                                      icon: Icon(
                                        Icons.clear,
                                        color: Colors.grey[400],
                                      ),
                                      onPressed: () {
                                        _trackingIdController.clear();
                                        setState(() {});
                                      },
                                    )
                                    : null,
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          onSubmitted: (_) => _trackPackage(),
                          onChanged: (value) => setState(() {}),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Botón de búsqueda mejorado
                  Container(
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors:
                            _isLoading || _trackingIdController.text.isEmpty
                                ? [Colors.grey[300]!, Colors.grey[400]!]
                                : [accentGreen, const Color(0xFF20A13A)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow:
                          _isLoading || _trackingIdController.text.isEmpty
                              ? []
                              : [
                                BoxShadow(
                                  color: accentGreen.withOpacity(0.3),
                                  offset: const Offset(0, 4),
                                  blurRadius: 12,
                                ),
                              ],
                    ),
                    child: ElevatedButton(
                      onPressed:
                          (_isLoading || _trackingIdController.text.isEmpty)
                              ? null
                              : _trackPackage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_isLoading) ...[
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Buscando...',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ] else ...[
                            const Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Buscar Envío',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Separador
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey[300])),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'O',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey[300])),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Botón QR mejorado
                  Container(
                    height: 56,
                    decoration: BoxDecoration(
                      border: Border.all(color: primaryBlue, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: OutlinedButton(
                      onPressed: _scanAndTrack,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.qr_code_scanner,
                            color: primaryBlue,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Escanear Código QR',
                            style: TextStyle(
                              fontSize: 16,
                              color: primaryBlue,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsView() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_packageData == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Paquete no encontrado',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No se encontró el paquete con el ID "${_trackingIdController.text}".',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Número de Guía:', style: TextStyle(color: Colors.grey)),
          Text(
            _packageData!['id'],
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          _StatusTimeline(currentStatus: _packageData!['status']),
        ],
      ),
    );
  }
}

// --- WIDGETS REUTILIZABLES PARA LA LÍNEA DE TIEMPO ---

class _StatusTimeline extends StatelessWidget {
  final PackageStatus currentStatus;

  const _StatusTimeline({required this.currentStatus});

  @override
  Widget build(BuildContext context) {
    // Definimos los pasos fijos de nuestro flujo de trabajo.
    final steps = [
      {
        'status': PackageStatus.receivedInCali,
        'title': 'Recibido en Cali',
        'icon': Icons.inventory_2_outlined,
      },
      {
        'status': PackageStatus.inWarehouse,
        'title': 'En bodega',
        'icon': Icons.warehouse_outlined,
      },
      {
        'status': PackageStatus.inTransitToBuenaventura,
        'title': 'En tránsito a Buenaventura',
        'icon': Icons.local_shipping_outlined,
      },
      {
        'status': PackageStatus.arrivedInBuenaventura,
        'title': 'Llegó a Buenaventura',
        'icon': Icons.inventory_2_outlined,
      },
      {
        'status': PackageStatus.outForDelivery,
        'title': 'En reparto',
        'icon': Icons.local_shipping_outlined,
      },
      {
        'status': PackageStatus.delivered,
        'title': 'Entregado',
        'icon': Icons.check_circle_outline,
      },
    ];

    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final status = step['status'] as PackageStatus;
        final isCompleted = currentStatus.index > status.index;
        final isCurrent = currentStatus.index == status.index;

        return _TimelineStep(
          title: step['title'] as String,
          icon: step['icon'] as IconData,
          isFirst: index == 0,
          isLast: index == steps.length - 1,
          isCompleted: isCompleted,
          isCurrent: isCurrent,
        );
      }),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isFirst, isLast, isCompleted, isCurrent;

  const _TimelineStep({
    required this.title,
    required this.icon,
    this.isFirst = false,
    this.isLast = false,
    this.isCompleted = false,
    this.isCurrent = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = theme.colorScheme.primary;
    final inactiveColor = Colors.grey[400]!;

    // El estado futuro es cuando no está ni completo ni es el actual
    final bool isFuture = !isCompleted && !isCurrent;
    final color = isFuture ? inactiveColor : activeColor;
    final fontWeight = isCurrent ? FontWeight.bold : FontWeight.normal;

    return IntrinsicHeight(
      child: Row(
        children: [
          // Columna para la línea de tiempo y el ícono
          Column(
            children: [
              Container(
                width: 1,
                height: 16,
                color: isFirst ? Colors.transparent : inactiveColor,
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: Icon(icon, color: color, size: 28),
              ),
              Container(
                width: 1,
                height: 16,
                color: isLast ? Colors.transparent : inactiveColor,
              ),
            ],
          ),
          const SizedBox(width: 20),
          // Título del estado
          Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: fontWeight,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
