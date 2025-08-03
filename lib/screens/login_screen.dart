import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String name = 'LoginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Colores corporativos mejorados
    const Color primaryBlue = Color(0xFF007BFF);
    const Color accentGreen = Color(0xFF28A745);
    const Color backgroundGradientStart = Color(0xFFF8FAFB);
    const Color backgroundGradientEnd = Color(0xFFE8F4F8);
    const Color cardShadow = Color(0x1A000000);

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [backgroundGradientStart, backgroundGradientEnd],
            ),
          ),
          child: SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Contenedor principal con sombra y bordes redondeados
                          Container(
                            width: double.infinity,
                            constraints: const BoxConstraints(maxWidth: 400),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: cardShadow,
                                  offset: const Offset(0, 8),
                                  blurRadius: 32,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Logo con círculo de fondo
                                  Center(
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            primaryBlue,
                                            primaryBlue.withOpacity(0.8),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: primaryBlue.withOpacity(0.3),
                                            offset: const Offset(0, 4),
                                            blurRadius: 12,
                                          ),
                                        ],
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'TX',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  // Título principal
                                  Center(
                                    child: Text(
                                      'ToPaX',
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey[900],
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  // Subtítulo
                                  Center(
                                    child: Text(
                                      'Rastrea tu envío fácil y rápido',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 40),

                                  // Campo de entrada mejorado
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Teléfono o correo electrónico',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(
                                                0.1,
                                              ),
                                              offset: const Offset(0, 2),
                                              blurRadius: 8,
                                            ),
                                          ],
                                        ),
                                        child: TextField(
                                          decoration: InputDecoration(
                                            hintText: 'ejemplo@correo.com',
                                            hintStyle: TextStyle(
                                              color: Colors.grey[400],
                                              fontSize: 16,
                                            ),
                                            filled: true,
                                            fillColor: Colors.grey[50],
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  vertical: 18.0,
                                                  horizontal: 20.0,
                                                ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              borderSide: BorderSide(
                                                color: Colors.grey[200]!,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              borderSide: BorderSide(
                                                color: Colors.grey[200]!,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              borderSide: const BorderSide(
                                                color: primaryBlue,
                                                width: 2,
                                              ),
                                            ),
                                            prefixIcon: Icon(
                                              Icons.alternate_email,
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 32),

                                  // Botón principal mejorado
                                  Container(
                                    height: 56,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          accentGreen,
                                          Color(0xFF20A13A),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: accentGreen.withOpacity(0.3),
                                          offset: const Offset(0, 4),
                                          blurRadius: 12,
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        context.go('/home'); // Navegar al HomeScreen por defecto
                                        
                                        // Aquí puedes agregar la lógica de validación
                                        // y navegación según el rol del usuario.
                                    // Ejemplo:
                                 /* final userRole = await _validateLogin(emailController.text);
  
                                     if (userRole == 'admin') {
                                        context.go('/admin');  // Ir al AdminHomeScreen
                                      } else if (userRole == 'user') {
                                     context.go('/home');   // Ir al HomeScreen normal
                                        } else {
                                             ScaffoldMessenger.of(context).showSnackBar(
                                           const SnackBar(content: Text('Credenciales inválidas')),
                                          );
                                        }  */
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12.0,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'Continuar',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  // Enlace de ayuda
                                  Center(
                                    child: TextButton(
                                      onPressed: () {
                                        context.go('/home');
                                      },
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                      ),
                                      child: Text(
                                        '¿Necesitas ayuda para ingresar?',
                                        style: TextStyle(
                                          color: primaryBlue,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Footer
                          Text(
                            '© 2025 ToPaX. Todos los derechos reservados.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
