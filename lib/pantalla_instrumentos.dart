import 'package:flutter/material.dart';
import 'piano_widget.dart';
import 'bateria_widget.dart';
import 'minijuego_ritmo.dart';

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
    return Column(
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

        Expanded(
          child: IndexedStack(
            index: currentInstrumentIndex,
            children: [
              const PianoWidget(),
              const BateriaWidget(),
              // 👇 Le pasamos true si estamos en la pestaña 2, o false si estamos en otra
              MinijuegoRitmo(isActive: currentInstrumentIndex == 2),
            ],
          ),
        ),
      ],
    );
  }
}
