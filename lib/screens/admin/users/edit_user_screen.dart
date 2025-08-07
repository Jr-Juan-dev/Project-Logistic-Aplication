import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditUserScreen extends StatefulWidget {
  final String userId;
  const EditUserScreen({super.key, required this.userId});
  static const String name = 'EditUserScreen';

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos del formulario
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _documentController = TextEditingController();

  String _selectedRole = 'Cliente';
  String _selectedDocumentType = 'Cédula';
  String _selectedStatus = 'Activo';
  bool _isLoading = false;
  bool _isLoadingData = true;

  final List<String> _roles = ['Cliente', 'Conductor', 'Administrador'];
  final List<String> _documentTypes = [
    'Cédula',
    'Pasaporte',
    'Tarjeta de identidad',
  ];
  final List<String> _statusOptions = ['Activo', 'Inactivo'];

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

    // Cargar datos del usuario
    _loadUserData();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _documentController.dispose();
    super.dispose();
  }

  void _loadUserData() async {
    // Simular carga de datos del usuario basado en widget.userId
    await Future.delayed(const Duration(seconds: 1));

    // Datos de ejemplo basados en el userId
    if (widget.userId == 'USR001') {
      _nameController.text = 'Carlos Rodríguez';
      _emailController.text = 'carlos.rodriguez@email.com';
      _phoneController.text = '+57 300 123 4567';
      _addressController.text =
          'Calle 123 #45-67, Buenaventura, Valle del Cauca';
      _documentController.text = '1234567890';
      _selectedRole = 'Conductor';
      _selectedDocumentType = 'Cédula';
      _selectedStatus = 'Activo';
    } else {
      // Usuario USR002 o cualquier otro
      _nameController.text = 'María González';
      _emailController.text = 'maria.gonzalez@email.com';
      _phoneController.text = '+57 301 987 6543';
      _addressController.text = 'Carrera 45 #78-90, Cali, Valle del Cauca';
      _documentController.text = '0987654321';
      _selectedRole = 'Cliente';
      _selectedDocumentType = 'Cédula';
      _selectedStatus = 'Activo';
    }

    setState(() {
      _isLoadingData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 768;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child:
            _isLoadingData
                ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF007BFF),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Cargando información del usuario...',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF1A1A1A),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
                : isDesktop
                ? _buildDesktopLayout(context)
                : _buildMobileLayout(context),
      ),
    );
  }

  // Layout compacto y centrado para escritorio
  Widget _buildDesktopLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 900,
          ), // Ancho máximo compacto
          margin: const EdgeInsets.symmetric(
            horizontal: 80.0,
          ), // Márgenes laterales considerables
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header compacto
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 20),
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF007BFF), Color(0xFF0056CC)],
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
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.go('/admin/users'),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 22,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.edit_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Editar Usuario',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'ID: ${widget.userId} - Modifique la información del usuario',
                            style: TextStyle(
                              fontSize: 13,
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

              // Formulario en dos columnas
              Form(
                key: _formKey,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Columna izquierda
                    Expanded(
                      child: Column(
                        children: [
                          // Información Personal
                          _buildSectionCard(
                            title: 'Información Personal',
                            icon: Icons.person_outline,
                            isDesktop: true,
                            children: [
                              _buildTextField(
                                controller: _nameController,
                                label: 'Nombre Completo',
                                hint: 'Ingrese el nombre completo',
                                icon: Icons.person,
                                isDesktop: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'El nombre es requerido';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              _buildDropdown(
                                label: 'Tipo de Documento',
                                value: _selectedDocumentType,
                                items: _documentTypes,
                                onChanged:
                                    (value) => setState(
                                      () => _selectedDocumentType = value!,
                                    ),
                                icon: Icons.badge_outlined,
                                isDesktop: true,
                              ),
                              const SizedBox(height: 16),
                              _buildTextField(
                                controller: _documentController,
                                label: 'Número de Documento',
                                hint: 'Ej: 1234567890',
                                icon: Icons.numbers,
                                keyboardType: TextInputType.number,
                                isDesktop: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'El documento es requerido';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Configuración de Cuenta
                          _buildSectionCard(
                            title: 'Configuración de Cuenta',
                            icon: Icons.settings_outlined,
                            isDesktop: true,
                            children: [
                              _buildDropdown(
                                label: 'Rol del Usuario',
                                value: _selectedRole,
                                items: _roles,
                                onChanged:
                                    (value) =>
                                        setState(() => _selectedRole = value!),
                                icon: Icons.admin_panel_settings_outlined,
                                isDesktop: true,
                              ),
                              const SizedBox(height: 16),
                              _buildDropdown(
                                label: 'Estado',
                                value: _selectedStatus,
                                items: _statusOptions,
                                onChanged:
                                    (value) => setState(
                                      () => _selectedStatus = value!,
                                    ),
                                icon: Icons.toggle_on_outlined,
                                isDesktop: true,
                              ),
                              const SizedBox(height: 16),

                              // Información adicional
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.blue[200]!),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: Colors.blue[600],
                                      size: 16,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Información del Sistema',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.blue[800],
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Los cambios se aplicarán inmediatamente. El usuario recibirá una notificación por email.',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.blue[700],
                                            ),
                                          ),
                                        ],
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

                    const SizedBox(width: 20),

                    // Columna derecha
                    Expanded(
                      child: Column(
                        children: [
                          // Información de Contacto
                          _buildSectionCard(
                            title: 'Información de Contacto',
                            icon: Icons.contact_phone_outlined,
                            isDesktop: true,
                            children: [
                              _buildTextField(
                                controller: _emailController,
                                label: 'Correo Electrónico',
                                hint: 'ejemplo@correo.com',
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                isDesktop: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'El email es requerido';
                                  }
                                  if (!value.contains('@')) {
                                    return 'Ingrese un email válido';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              _buildTextField(
                                controller: _phoneController,
                                label: 'Número de Teléfono',
                                hint: '+57 300 123 4567',
                                icon: Icons.phone_outlined,
                                keyboardType: TextInputType.phone,
                                isDesktop: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'El teléfono es requerido';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              _buildTextField(
                                controller: _addressController,
                                label: 'Dirección',
                                hint: 'Calle 123 #45-67, Barrio, Ciudad',
                                icon: Icons.location_on_outlined,
                                maxLines: 2,
                                isDesktop: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'La dirección es requerida';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Boton de acción
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF007BFF), Color(0xFF0056CC)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF007BFF).withOpacity(0.3),
                            offset: const Offset(0, 4),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _updateUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child:
                            _isLoading
                                ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                                : const Text(
                                  'Actualizar Usuario',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                      ),
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

  // Layout original para móvil (sin cambios)
  Widget _buildMobileLayout(BuildContext context) {
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
            onPressed: () => context.go('/admin/users'),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF007BFF), Color(0xFF0056CC)],
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
                              Icons.edit_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Editar Usuario',
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
                        'ID: ${widget.userId} - Modifique la información del usuario',
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Información Personal
                    _buildSectionCard(
                      title: 'Información Personal',
                      icon: Icons.person_outline,
                      isDesktop: false,
                      children: [
                        _buildTextField(
                          controller: _nameController,
                          label: 'Nombre Completo',
                          hint: 'Ingrese el nombre completo',
                          icon: Icons.person,
                          isDesktop: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'El nombre es requerido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDropdown(
                                label: 'Tipo de Documento',
                                value: _selectedDocumentType,
                                items: _documentTypes,
                                onChanged:
                                    (value) => setState(
                                      () => _selectedDocumentType = value!,
                                    ),
                                icon: Icons.badge_outlined,
                                isDesktop: false,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildTextField(
                                controller: _documentController,
                                label: 'Número de Documento',
                                hint: 'Ej: 1234567890',
                                icon: Icons.numbers,
                                keyboardType: TextInputType.number,
                                isDesktop: false,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'El documento es requerido';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Información de Contacto
                    _buildSectionCard(
                      title: 'Información de Contacto',
                      icon: Icons.contact_phone_outlined,
                      isDesktop: false,
                      children: [
                        _buildTextField(
                          controller: _emailController,
                          label: 'Correo Electrónico',
                          hint: 'ejemplo@correo.com',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          isDesktop: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'El email es requerido';
                            }
                            if (!value.contains('@')) {
                              return 'Ingrese un email válido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _phoneController,
                          label: 'Número de Teléfono',
                          hint: '+57 300 123 4567',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          isDesktop: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'El teléfono es requerido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _addressController,
                          label: 'Dirección',
                          hint: 'Calle 123 #45-67, Barrio, Ciudad',
                          icon: Icons.location_on_outlined,
                          maxLines: 2,
                          isDesktop: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'La dirección es requerida';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Configuración de Cuenta
                    _buildSectionCard(
                      title: 'Configuración de Cuenta',
                      icon: Icons.settings_outlined,
                      isDesktop: false,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildDropdown(
                                label: 'Rol del Usuario',
                                value: _selectedRole,
                                items: _roles,
                                onChanged:
                                    (value) =>
                                        setState(() => _selectedRole = value!),
                                icon: Icons.admin_panel_settings_outlined,
                                isDesktop: false,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildDropdown(
                                label: 'Estado',
                                value: _selectedStatus,
                                items: _statusOptions,
                                onChanged:
                                    (value) => setState(
                                      () => _selectedStatus = value!,
                                    ),
                                icon: Icons.toggle_on_outlined,
                                isDesktop: false,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Información adicional
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue[200]!),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.blue[600],
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Información del Sistema',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue[800],
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Los cambios se aplicarán inmediatamente. El usuario recibirá una notificación por email.',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blue[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Boton de acción
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF007BFF), Color(0xFF0056CC)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF007BFF,
                                  ).withOpacity(0.3),
                                  offset: const Offset(0, 4),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _updateUser,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child:
                                  _isLoading
                                      ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                      : const Text(
                                        'Actualizar Usuario',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                            ),
                          ),
                        ),
                      ],
                    ),
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

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
    required bool isDesktop,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isDesktop ? 14 : 16),
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
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isDesktop ? 6 : 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF28A745).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(isDesktop ? 6 : 8),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF28A745),
                    size: isDesktop ? 16 : 20,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isDesktop ? 16 : 18,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
            SizedBox(height: isDesktop ? 16 : 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isDesktop,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isDesktop ? 12 : 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        SizedBox(height: isDesktop ? 6 : 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: isDesktop ? 13 : 14,
            ),
            prefixIcon: Icon(
              icon,
              color: Colors.grey[400],
              size: isDesktop ? 18 : 20,
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: EdgeInsets.symmetric(
              vertical: isDesktop ? 12.0 : 16.0,
              horizontal: isDesktop ? 16.0 : 20.0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(isDesktop ? 10.0 : 12.0),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(isDesktop ? 10.0 : 12.0),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(isDesktop ? 10.0 : 12.0),
              borderSide: const BorderSide(color: Color(0xFF28A745), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(isDesktop ? 10.0 : 12.0),
              borderSide: const BorderSide(color: Color(0xFFDC3545), width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(isDesktop ? 10.0 : 12.0),
              borderSide: const BorderSide(color: Color(0xFFDC3545), width: 2),
            ),
          ),
          style: TextStyle(fontSize: isDesktop ? 13 : 14),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
    required IconData icon,
    required bool isDesktop,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isDesktop ? 12 : 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        SizedBox(height: isDesktop ? 6 : 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(isDesktop ? 10 : 12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            onChanged: onChanged,
            style: TextStyle(
              fontSize: isDesktop ? 13 : 14,
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: Colors.grey[400],
                size: isDesktop ? 18 : 20,
              ),
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: EdgeInsets.symmetric(
                vertical: isDesktop ? 12.0 : 16.0,
                horizontal: isDesktop ? 16.0 : 20.0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(isDesktop ? 10.0 : 12.0),
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(isDesktop ? 10.0 : 12.0),
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(isDesktop ? 10.0 : 12.0),
                borderSide: const BorderSide(
                  color: Color(0xFF28A745),
                  width: 2,
                ),
              ),
            ),
            items:
                items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(fontSize: isDesktop ? 13 : 14),
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }
}

void _updateUser() async {
  // Regresar a la lista de usuarios
}
