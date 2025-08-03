import 'package:flutter/material.dart';

class DeliveryReportsScreen extends StatelessWidget {
  static const String name = 'DeliveryReportsScreen';

  const DeliveryReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reportes de Entrega')),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: const [
          ReportCard(title: 'Entrega #1', description: 'Paquete entregado en 24h'),
          ReportCard(title: 'Entrega #2', description: 'Demora por clima'),
        ],
      ),
    );
  }
}

class ReportCard extends StatelessWidget {
  final String title;
  final String description;

  const ReportCard({required this.title, required this.description, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(description, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}