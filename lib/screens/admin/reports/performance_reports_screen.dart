import 'package:flutter/material.dart';

class PerformanceReportsScreen extends StatelessWidget {
  static const String name = 'PerformanceReportsScreen';

  const PerformanceReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rendimiento de Entregas')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(title: Text('Eficiencia semanal'), subtitle: Text('85%')), 
          ListTile(title: Text('Entregas a tiempo'), subtitle: Text('92%')),
        ],
      ),
    );
  }
}