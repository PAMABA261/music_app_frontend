import 'package:flutter/material.dart';
import 'piano_widget.dart';
import 'bateria_widget.dart';
import 'minijuego_ritmo.dart';
import 'pantalla_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PantallaInstrumentos extends StatefulWidget {
  const PantallaInstrumentos({super.key});

  @override
  State<PantallaInstrumentos> createState() => _PantallaInstrumentosState();
}

class _PantallaInstrumentosState extends State<PantallaInstrumentos> {
  int currentInstrumentIndex = 0;
  final List<String> instruments = ['Piano', 'Batería', 'Minijuego de Ritmo'];

  void _changeInstrument(int direction) {
    setState(() {
      currentInstrumentIndex += direction;
      if (currentInstrumentIndex < 0) {
        currentInstrumentIndex = instruments.length - 1;
      } else if (currentInstrumentIndex >= instruments.length) {
        currentInstrumentIndex = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 👇 1. AÑADIMOS EL SCAFFOLD (El lienzo blanco)
    return Scaffold(
      backgroundColor: Colors.white,

      // 👇 2. AQUÍ ENTRA EL APPBAR (La barra superior con el botón de Salir)
      appBar: AppBar(
        title: const Text(
          'TFG Música',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              // 👇 BORRAMOS EL TOKEN DE LA MEMORIA ANTES DE SALIR
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('token_jwt');

              if (!context.mounted) return;

              // Navegamos de vuelta al Login y destruimos esta pantalla
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PantallaLogin()),
              );
            },
          ),
        ],
      ),

      // 👇 3. AÑADIMOS EL SAFEAREA (El cuerpo principal)
      body: SafeArea(
        child: Column(
          children: [
            // SELECTOR SUPERIOR
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              color: Colors.grey[200],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () => _changeInstrument(-1),
                  ),
                  SizedBox(
                    width: 170,
                    child: Text(
                      instruments[currentInstrumentIndex],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: () => _changeInstrument(1),
                  ),
                ],
              ),
            ),

            // INSTRUMENTOS Y MINIJUEGO
            Expanded(
              child: IndexedStack(
                index: currentInstrumentIndex,
                children: [
                  const PianoWidget(),
                  const BateriaWidget(),
                  MinijuegoRitmo(isActive: currentInstrumentIndex == 2),
                ],
              ),
            ),
          ],
        ),
      ), // Cierre del SafeArea
    ); // Cierre del Scaffold
  }
}
