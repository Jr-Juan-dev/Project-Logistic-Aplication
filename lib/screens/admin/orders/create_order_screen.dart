// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});
  static const String name = 'CreateOrderScreen';

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Controladores de formulario
  final _formKey = GlobalKey<FormState>();
  final _clientNameController = TextEditingController();
  final _clientPhoneController = TextEditingController();
  final _clientEmailController = TextEditingController();
  final _originAddressController = TextEditingController();
  final _destinationAddressController = TextEditingController();
  final _packageCountController = TextEditingController();
  final _weightController = TextEditingController();
  final _specialInstructionsController = TextEditingController();

  String _selectedOriginZone = 'Centro';
  String _selectedDestinationZone = 'Terminal';
  String _selectedPriority = 'media';
  DateTime _selectedDeliveryDate = DateTime.now().add(const Duration(days: 1));

  final List<String> _caliZones = ['Centro', 'Norte', 'Sur', 'Este', 'Oeste'];
  final List<String> _buenaventuraZones = ['Terminal', 'Puerto', 'Centro', 'Industrial'];
  final List<String> _priorities = ['baja', 'media', 'alta'];

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
    _clientNameController.dispose();
    _clientPhoneController.dispose();
    _clientEmailController.dispose();
    _originAddressController.dispose();
    _destinationAddressController.dispose();
    _packageCountController.dispose();
    _weightController.dispose();
    _specialInstructionsController.dispose();
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

  // Layout mejorado para escritorio con mejor distribución
  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200), // Aumentado para mejor distribución
          margin: const EdgeInsets.symmetric(horizontal: 60.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header administrativo compacto
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF007BFF), Color(0xFF0056B3)],
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
                        onPressed: () => context.go('/admin/orders'),
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                        tooltip: 'Volver a la lista de pedidos',
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.add_box,
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
                              'Crear Nuevo Pedido',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 28,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Complete todos los campos para crear el pedido',
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

              // Formulario con distribución mejorada (3 columnas)
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Primera fila: Información del Cliente + Información del Envío (más ancha) + Detalles del Paquete
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Columna 1: Cliente (30%)
                        Expanded(
                          flex: 3,
                          child: _buildClientSection(true),
                        ),
                        const SizedBox(width: 16),
                        
                        // Columna 2: Envío (40% - más ancha)
                        Expanded(
                          flex: 4,
                          child: _buildShippingSection(true),
                        ),
                        const SizedBox(width: 16),
                        
                        // Columna 3: Paquete (30%)
                        Expanded(
                          flex: 3,
                          child: _buildPackageSection(true),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),

                    // Segunda fila: Configuración Adicional (centrada) + Botones
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Espacio vacío para centrar
                        Expanded(
                          flex: 2,
                          child: Container(),
                        ),
                        
                        // Configuración Adicional centrada
                        Expanded(
                          flex: 6,
                          child: _buildAdditionalSection(true),
                        ),
                        
                        // Espacio vacío para centrar
                        Expanded(
                          flex: 2,
                          child: Container(),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),

                    // Botones de acción centrados
                    SizedBox(
                      width: 400,
                      child: _buildActionButtons(true),
                    ),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
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
            onPressed: () => context.go('/admin/orders'),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
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
                              Icons.add_box,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Crear Nuevo Pedido',
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
                        'Complete todos los campos para crear el pedido',
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Información del cliente
                    _buildClientSection(false),
                    const SizedBox(height: 32),

                    // Información del envío
                    _buildShippingSection(false),
                    const SizedBox(height: 32),

                    // Detalles del paquete
                    _buildPackageSection(false),
                    const SizedBox(height: 32),

                    // Configuración adicional
                    _buildAdditionalSection(false),
                    const SizedBox(height: 32),

                    // Botones de acción
                    _buildActionButtons(false),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ],
    );
  }

  Widget _buildClientSection(bool isDesktop) {
    return Container(
      height: isDesktop ? 420 : null, // Altura fija para escritorio para alinear con otras columnas
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
        padding: EdgeInsets.all(isDesktop ? 20.0 : 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Información del Cliente',
              style: TextStyle(
                fontSize: isDesktop ? 18 : 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            SizedBox(height: isDesktop ? 14 : 20),
            TextFormField(
              controller: _clientNameController,
              decoration: _inputDecoration(
                label: 'Nombre completo',
                icon: Icons.person,
                isDesktop: isDesktop,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese el nombre del cliente';
                }
                return null;
              },
            ),
            SizedBox(height: isDesktop ? 30 : 16),
            TextFormField(
              controller: _clientPhoneController,
              decoration: _inputDecoration(
                label: 'Teléfono',
                icon: Icons.phone,
                isDesktop: isDesktop,
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese el teléfono del cliente';
                }
                return null;
              },
            ),
            SizedBox(height: isDesktop ? 30 : 16),
            TextFormField(
              controller: _clientEmailController,
              decoration: _inputDecoration(
                label: 'Email (opcional)',
                icon: Icons.email,
                isDesktop: isDesktop,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingSection(bool isDesktop) {
    return Container(
      height: isDesktop ? 420 : null, // Altura fija para escritorio
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
        padding: EdgeInsets.all(isDesktop ? 20.0 : 24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Información del Envío',
                style: TextStyle(
                  fontSize: isDesktop ? 18 : 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              SizedBox(height: isDesktop ? 14 : 20),
              
              // Origen
              Text(
                'Origen (Cali)',
                style: TextStyle(
                  fontSize: isDesktop ? 12 : 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              SizedBox(height: isDesktop ? 10 : 8),
              DropdownButtonFormField<String>(
                value: _selectedOriginZone,
                decoration: _inputDecoration(
                  label: 'Zona de Cali',
                  icon: Icons.location_on,
                  isDesktop: isDesktop,
                ),
                items: _caliZones.map((zone) {
                  return DropdownMenuItem(
                    value: zone,
                    child: Text(zone),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedOriginZone = value!;
                  });
                },
              ),
              SizedBox(height: isDesktop ? 8 : 16),
              TextFormField(
                controller: _originAddressController,
                decoration: _inputDecoration(
                  label: 'Dirección completa de origen',
                  icon: Icons.home,
                  isDesktop: isDesktop,
                ),
                maxLines: isDesktop ? 2 : 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la dirección de origen';
                  }
                  return null;
                },
              ),
              SizedBox(height: isDesktop ? 12 : 24),

              // Destino
              Text(
                'Destino (Buenaventura)',
                style: TextStyle(
                  fontSize: isDesktop ? 12 : 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              SizedBox(height: isDesktop ? 10 : 8),
              DropdownButtonFormField<String>(
                value: _selectedDestinationZone,
                decoration: _inputDecoration(
                  label: 'Zona de Buenaventura',
                  icon: Icons.location_on_outlined,
                  isDesktop: isDesktop,
                ),
                items: _buenaventuraZones.map((zone) {
                  return DropdownMenuItem(
                    value: zone,
                    child: Text(zone),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDestinationZone = value!;
                  });
                },
              ),
              SizedBox(height: isDesktop ? 8 : 16),
              TextFormField(
                controller: _destinationAddressController,
                decoration: _inputDecoration(
                  label: 'Dirección completa de destino',
                  icon: Icons.location_city,
                  isDesktop: isDesktop,
                ),
                maxLines: isDesktop ? 2 : 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la dirección de destino';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPackageSection(bool isDesktop) {
    return Container(
      height: isDesktop ? 420 : null, // Altura fija para escritorio
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
        padding: EdgeInsets.all(isDesktop ? 20.0 : 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detalles del Paquete',
              style: TextStyle(
                fontSize: isDesktop ? 18 : 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            SizedBox(height: isDesktop ? 14 : 20),
            
            // En escritorio: Campos en columna para mejor uso del espacio vertical
            if (isDesktop) ...[
              TextFormField(
                controller: _packageCountController,
                decoration: _inputDecoration(
                  label: 'Cantidad de paquetes',
                  icon: Icons.inventory_2,
                  isDesktop: isDesktop,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese la cantidad';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Cantidad inválida';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _weightController,
                decoration: _inputDecoration(
                  label: 'Peso total (kg)',
                  icon: Icons.scale,
                  isDesktop: isDesktop,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese el peso';
                  }
                  if (double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Peso inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _specialInstructionsController,
                decoration: _inputDecoration(
                  label: 'Instrucciones especiales',
                  icon: Icons.note,
                  isDesktop: isDesktop,
                ),
                maxLines: 3,
              ),
            ] else ...[
              // En móvil: Layout original en fila
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _packageCountController,
                      decoration: _inputDecoration(
                        label: 'Cantidad de paquetes',
                        icon: Icons.inventory_2,
                        isDesktop: isDesktop,
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese la cantidad';
                        }
                        if (int.tryParse(value) == null || int.parse(value) <= 0) {
                          return 'Cantidad inválida';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _weightController,
                      decoration: _inputDecoration(
                        label: 'Peso total (kg)',
                        icon: Icons.scale,
                        isDesktop: isDesktop,
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese el peso';
                        }
                        if (double.tryParse(value) == null || double.parse(value) <= 0) {
                          return 'Peso inválido';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _specialInstructionsController,
                decoration: _inputDecoration(
                  label: 'Instrucciones especiales (opcional)',
                  icon: Icons.note,
                  isDesktop: isDesktop,
                ),
                maxLines: 3,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalSection(bool isDesktop) {
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
        padding: EdgeInsets.all(isDesktop ? 18.0 : 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configuración Adicional',
              style: TextStyle(
                fontSize: isDesktop ? 18 : 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            SizedBox(height: isDesktop ? 20 : 20),
            
            // Prioridad
            Text(
              'Prioridad del pedido',
              style: TextStyle(
                fontSize: isDesktop ? 16 : 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            SizedBox(height: isDesktop ? 12 : 12),
            _buildMobilePriorityRow(isDesktop), // Usar siempre el layout en fila
            SizedBox(height: isDesktop ? 14 : 24),

            // Fecha de entrega
            Text(
              'Fecha de entrega estimada',
              style: TextStyle(
                fontSize: isDesktop ? 16 : 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            SizedBox(height: isDesktop ? 12 : 12),
            InkWell(
              onTap: _selectDeliveryDate,
              child: Container(
                padding: EdgeInsets.all(isDesktop ? 10 : 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today, 
                      color: const Color(0xFF007BFF),
                      size: isDesktop ? 16 : 20,
                    ),
                    SizedBox(width: isDesktop ? 12 : 12),
                    Text(
                      '${_selectedDeliveryDate.day}/${_selectedDeliveryDate.month}/${_selectedDeliveryDate.year}',
                      style: TextStyle(
                        fontSize: isDesktop ? 16 : 16,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_drop_down, 
                      color: Colors.grey,
                      size: isDesktop ? 18 : 24,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobilePriorityRow([bool isDesktop = false]) {
    return Row(
      children: _priorities.map((priority) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: isDesktop ? 6 : 8),
            child: _PriorityOption(
              priority: priority,
              isSelected: _selectedPriority == priority,
              onTap: () => setState(() => _selectedPriority = priority),
              isDesktop: isDesktop,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons(bool isDesktop) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: isDesktop ? 48 : 56,
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
            onPressed: _createOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            icon: Icon(
              Icons.check, 
              color: Colors.white,
              size: isDesktop ? 18 : 20,
            ),
            label: Text(
              'Crear Pedido',
              style: TextStyle(
                fontSize: isDesktop ? 16 : 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    required bool isDesktop,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(
        icon, 
        color: const Color(0xFF007BFF),
        size: isDesktop ? 16 : 20,
      ),
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: EdgeInsets.symmetric(
        vertical: isDesktop ? 10.0 : 16.0,
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
        borderSide: const BorderSide(color: Color(0xFF007BFF), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: Color(0xFFDC3545), width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: Color(0xFFDC3545), width: 2),
      ),
    );
  }

  Future<void> _selectDeliveryDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDeliveryDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF007BFF),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDeliveryDate) {
      setState(() {
        _selectedDeliveryDate = picked;
      });
    }
  }

  void _createOrder() {
    if (_formKey.currentState!.validate()) {
      // Aquí iría la lógica para crear el pedido
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('Pedido Creado'),
            content: const Text('El pedido ha sido creado exitosamente.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go('/admin/orders');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF28A745),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Continuar'),
              ),
            ],
          );
        },
      );
    }
  }
}

// Widget para las opciones de prioridad
class _PriorityOption extends StatelessWidget {
  final String priority;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDesktop;

  const _PriorityOption({
    required this.priority,
    required this.isSelected,
    required this.onTap,
    required this.isDesktop,
  });

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

  String _getPriorityText(String priority) {
    switch (priority) {
      case 'alta':
        return 'Alta';
      case 'media':
        return 'Media';
      case 'baja':
        return 'Baja';
      default:
        return priority;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getPriorityColor(priority);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: isDesktop ? 6 : 12, 
          horizontal: isDesktop ? 8 : 16
        ),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? color : Colors.grey[400],
              size: isDesktop ? 14 : 20,
            ),
            SizedBox(height: isDesktop ? 3 : 8),
            Text(
              _getPriorityText(priority),
              style: TextStyle(
                fontSize: isDesktop ? 11 : 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? color : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}