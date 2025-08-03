import 'package:flutter/material.dart';

class RouteOptimizationScreen extends StatelessWidget {
  static const String name = 'RouteOptimizationScreen';

  const RouteOptimizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Optimización de Rutas')),
      body: Center(
        child: Text('Herramientas de optimización en construcción',
            style: Theme.of(context).textTheme.titleMedium),
      ),
    );
  }
}