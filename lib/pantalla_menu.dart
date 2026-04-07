import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pantalla_login.dart';
import 'pantalla_instrumentos.dart';
import 'pantalla_lecciones.dart';

class PantallaMenu extends StatelessWidget {
  const PantallaMenu({super.key});

  // Moveremos la función de cerrar sesión aquí, al menú principal
  Future<void> _cerrarSesion(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token_jwt');

    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const PantallaLogin()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú Principal'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () => _cerrarSesion(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // BOTÓN MODO ACADEMIA (Lecciones)
            _crearTarjeta(
              context: context,
              titulo: 'Modo Academia',
              subtitulo: 'Aprende teoría y supera retos',
              icono: Icons.school,
              colorFondo: Colors.teal,
              pantallaDestino: const PantallaLecciones(),
            ),
            const SizedBox(height: 30),

            // BOTÓN MODO LIBRE (Instrumentos)
            _crearTarjeta(
              context: context,
              titulo: 'Modo Libre',
              subtitulo: 'Toca los instrumentos a tu ritmo',
              icono: Icons.piano,
              colorFondo: Colors.orange,
              pantallaDestino: const PantallaInstrumentos(),
            ),
          ],
        ),
      ),
    );
  }

  // Widget reutilizable para crear los botones gigantes
  Widget _crearTarjeta({
    required BuildContext context,
    required String titulo,
    required String subtitulo,
    required IconData icono,
    required Color colorFondo,
    required Widget pantallaDestino,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => pantallaDestino),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colorFondo,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icono, size: 60, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitulo,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
