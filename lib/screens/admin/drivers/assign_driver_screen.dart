import 'package:flutter/material.dart';

class AssignDriverScreen extends StatelessWidget {
  final String orderId;

  const AssignDriverScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Asignar Conductor: Pedido #$orderId')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Selecciona un conductor disponible:',
                style: TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Conductor 1 - Camión ABC123'),
              trailing: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Conductor asignado a pedido #$orderId')),
                  );
                },
                child: const Text('Asignar'),
              ),
            ),
            ListTile(
              title: const Text('Conductor 2 - Camión XYZ789'),
              trailing: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Conductor asignado a pedido #$orderId')),
                  );
                },
                child: const Text('Asignar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}