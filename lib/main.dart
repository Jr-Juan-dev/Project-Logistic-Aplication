import 'package:flutter/material.dart';
import 'package:topax/router/app_router.dart'; // Asegúrate de que la ruta sea correcta

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Topax Express', // Nombre más acorde
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3A7DB7)),
        useMaterial3: true,
      ),
      routerConfig: appRouter, // Usamos la instancia del router
    );
  }
}