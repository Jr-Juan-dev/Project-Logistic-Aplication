import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Volvemos a convertirlo en un StatefulWidget para poder manejar la lógica de WillPopScope.
class BarraNavInferior extends StatefulWidget {
  final Widget child;
  const BarraNavInferior({super.key, required this.child});
  static const String name = 'BarraNavInferior';

  @override
  State<BarraNavInferior> createState() => _BarraNavInferiorState();
}

class _BarraNavInferiorState extends State<BarraNavInferior> {
  // Función para obtener el índice actual basado en la ruta.
  int _calculateSelectedIndex() {
    // Usamos .uri.path que es la forma correcta y moderna.
    final String location = GoRouterState.of(context).uri.path;
    
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/history')) return 1;
    if (location.startsWith('/tracking')) return 2;
    if (location.startsWith('/perfil')) return 3;
    
    return 0; // Por defecto, el índice del home.
  }

  // Función para navegar al hacer tap en un ítem.
  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/history');
        break;
      case 2:
        context.go('/tracking');
        break;
      case 3:
        context.go('/perfil');
        break;
    }
  }

  // ESTA ES LA LÓGICA CLAVE RESTAURADA
  // Se ejecuta cuando el usuario presiona el botón de retroceso del sistema.
  Future<bool> _onWillPop() async {
    // Si el índice actual NO es el de la pantalla de inicio (0)
    if (_calculateSelectedIndex() != 0) {
      // Navega a la pantalla de inicio.
      context.go('/home');
      // Retorna 'false' para decirle al sistema: "Yo manejé el evento, no cierres la app".
      return false;
    }
    // Si ya estamos en la pantalla de inicio, retorna 'true' para permitir que se cierre la app.
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // Envolvemos el Scaffold con WillPopScope para interceptar el botón de retroceso.
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: widget.child, 
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _calculateSelectedIndex(),
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey[600],
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_outlined),
              activeIcon: Icon(Icons.history),
              label: 'Historial',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_shipping_outlined),
              activeIcon: Icon(Icons.local_shipping),
              label: 'Seguimiento',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}