import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pantalla_login.dart';
import 'pantalla_instrumentos.dart';
import 'pantalla_menu.dart';

class PantallaCarga extends StatefulWidget {
  const PantallaCarga({super.key});

  @override
  State<PantallaCarga> createState() => _PantallaCargaState();
}

class _PantallaCargaState extends State<PantallaCarga> {
  @override
  void initState() {
    super.initState();
    _comprobarSesion();
  }

  Future<void> _comprobarSesion() async {
    // Añadimos un pequeño retraso de 1 segundo por pura estética,
    // para que al usuario le dé tiempo a ver el logo al abrir la app.
    await Future.delayed(const Duration(seconds: 1));

    // 1. Buscamos en la memoria interna
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token_jwt');

    if (!mounted) return;

    // 2. Tomamos la decisión
    if (token != null && token.isNotEmpty) {
      // ¡Hay pulsera VIP! Directo al estudio musical.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PantallaMenu()),
      );
    } else {
      // No hay pulsera. Toca pasar por taquilla.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PantallaLogin()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.music_note, size: 100, color: Colors.white),
            SizedBox(height: 20),
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 20),
            Text(
              'Cargando tu estudio...',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
