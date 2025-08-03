import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportes del Sistema'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Card(
            child: ListTile(
              title: Text('Reporte de entregas por conductor'),
              subtitle: Text('Revisa las entregas realizadas por cada conductor'),
              trailing: Icon(Icons.bar_chart),
            ),
          ),
          SizedBox(height: 12),
          Card(
            child: ListTile(
              title: Text('Reporte de entregas por ruta'),
              subtitle: Text('Visualiza las entregas agrupadas por ruta asignada'),
              trailing: Icon(Icons.route),
            ),
          ),
        ],
      ),
    );
  }
}