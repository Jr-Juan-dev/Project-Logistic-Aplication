import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  static const String name = 'AnalyticsScreen';

  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Análisis de Datos')),
      body: Center(
        child: Text('Próximamente: Gráficas de análisis',
            style: Theme.of(context).textTheme.titleMedium),
      ),
    );
  }
}