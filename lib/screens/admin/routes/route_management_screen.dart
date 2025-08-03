import 'package:flutter/material.dart';

class RouteManagementScreen extends StatelessWidget {
  static const String name = 'RouteManagementScreen';

  const RouteManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Rutas')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(title: Text('Ruta A-B'), subtitle: Text('Activa')),
          ListTile(title: Text('Ruta C-D'), subtitle: Text('Inactiva')),
        ],
      ),
    );
  }
}
