import 'package:flutter/material.dart';

class RouteTrackingScreen extends StatelessWidget {
  static const String name = 'RouteTrackingScreen';

  const RouteTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seguimiento de Ruta')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(title: Text('Camión #1'), subtitle: Text('Última ubicación: Palmira')),
          ListTile(title: Text('Camión #2'), subtitle: Text('Última ubicación: Buga')),
        ],
      ),
    );
  }
}