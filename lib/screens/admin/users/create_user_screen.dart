// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});
  static const String name = 'CreateUserScreen';

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen>
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
  bool _sendWelcomeEmail = true;
  bool _isLoading = false;

  final List<String> _roles = ['Cliente', 'Conductor', 'Administrador'];
  final List<String> _documentTypes = ['Cédula', 'Pasaporte', 'Tarjeta de identidad'];
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

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 768;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: isDesktop ? _buildDesktopLayout(context) : _buildMobileLayout(context),
      ),
    );
  }

  // Layout compacto y centrado para escritorio
  Widget _buildDesktopLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 900), // Ancho máximo compacto
          margin: const EdgeInsets.symmetric(horizontal: 80.0), // Márgenes laterales considerables
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
                    colors: [Color(0xFF28A745), Color(0xFF20A13A)],
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
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                      tooltip: 'Volver a la lista de usuarios',
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.person_add_outlined,
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
                            'Crear Nuevo Usuario',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Complete la información del nuevo usuario',
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
                                onChanged: (value) => setState(() => _selectedDocumentType = value!),
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
                                onChanged: (value) => setState(() => _selectedRole = value!),
                                icon: Icons.admin_panel_settings_outlined,
                                isDesktop: true,
                              ),
                              const SizedBox(height: 16),
                              _buildDropdown(
                                label: 'Estado Inicial',
                                value: _selectedStatus,
                                items: _statusOptions,
                                onChanged: (value) => setState(() => _selectedStatus = value!),
                                icon: Icons.toggle_on_outlined,
                                isDesktop: true,
                              ),
                              const SizedBox(height: 16),
                              
                              // Opciones adicionales
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey[200]!),
                                ),
                                child: CheckboxListTile(
                                  value: _sendWelcomeEmail,
                                  onChanged: (value) => setState(() => _sendWelcomeEmail = value!),
                                  title: const Text(
                                    'Enviar email de bienvenida',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text(
                                    'Se enviará un correo con las credenciales de acceso',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  activeColor: const Color(0xFF28A745),
                                  contentPadding: EdgeInsets.zero,
                                  controlAffinity: ListTileControlAffinity.leading,
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

              // Botones de acción
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF28A745), Color(0xFF20A13A)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF28A745).withOpacity(0.3),
                            offset: const Offset(0, 4),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _createUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Crear Usuario',
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
                              Icons.person_add_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Crear Nuevo Usuario',
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
                        'Complete la información del nuevo usuario',
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
                                onChanged: (value) => setState(() => _selectedDocumentType = value!),
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
                                onChanged: (value) => setState(() => _selectedRole = value!),
                                icon: Icons.admin_panel_settings_outlined,
                                isDesktop: false,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildDropdown(
                                label: 'Estado Inicial',
                                value: _selectedStatus,
                                items: _statusOptions,
                                onChanged: (value) => setState(() => _selectedStatus = value!),
                                icon: Icons.toggle_on_outlined,
                                isDesktop: false,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        
                        // Opciones adicionales
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Opciones Adicionales',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                              const SizedBox(height: 12),
                              CheckboxListTile(
                                value: _sendWelcomeEmail,
                                onChanged: (value) => setState(() => _sendWelcomeEmail = value!),
                                title: const Text(
                                  'Enviar email de bienvenida',
                                  style: TextStyle(fontSize: 14),
                                ),
                                subtitle: Text(
                                  'Se enviará un correo con las credenciales de acceso',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                activeColor: const Color(0xFF28A745),
                                contentPadding: EdgeInsets.zero,
                                controlAffinity: ListTileControlAffinity.leading,
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
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _createUser,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text(
                                    'Crear Usuario',
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
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: isDesktop ? 13 : 14),
            prefixIcon: Icon(icon, color: Colors.grey[400], size: isDesktop ? 18 : 20),
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
            style: TextStyle(fontSize: isDesktop ? 13 : 14, color: Colors.black87),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.grey[400], size: isDesktop ? 18 : 20),
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
            ),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item, style: TextStyle(fontSize: isDesktop ? 13 : 14)),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _createUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      // Simular creación de usuario
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() => _isLoading = false);
      
      if (mounted) {
        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Usuario ${_nameController.text} creado exitosamente'
                    '${_sendWelcomeEmail ? '. Email de bienvenida enviado.' : ''}',
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF28A745),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
        
        // Regresar a la lista de usuarios
        context.go('/admin/users');
      }
    }
  }
}