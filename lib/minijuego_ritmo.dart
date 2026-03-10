import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MinijuegoRitmo extends StatefulWidget {
  final bool
  isActive; // 👈 1. Nueva variable para saber si estamos en esta pestaña

  const MinijuegoRitmo({super.key, required this.isActive});

  @override
  State<MinijuegoRitmo> createState() => _MinijuegoRitmoState();
}

class _MinijuegoRitmoState extends State<MinijuegoRitmo> {
  final int bpm = 120;
  late int msPorBeat;

  Stopwatch _cronometro = Stopwatch();
  Timer? _metronomoVisual;
  final AudioPlayer _metronomoPlayer = AudioPlayer();

  String _mensaje = "¡Escucha el ritmo!";
  Color _colorMensaje = Colors.white;
  double _escala = 1.0;
  int _combo = 0;

  @override
  void initState() {
    super.initState();
    msPorBeat = (60000 / bpm).round();
    _metronomoPlayer.setSource(AssetSource('audio/caja.mp3'));

    // Solo arrancamos si la pestaña es visible desde el principio
    if (widget.isActive) {
      _iniciarJuego();
    }
  }

  // 👈 2. Este método mágico de Flutter detecta cuando cambias de pestaña
  @override
  void didUpdateWidget(MinijuegoRitmo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      // Si acabamos de entrar a esta pestaña, ¡Play!
      _iniciarJuego();
    } else if (!widget.isActive && oldWidget.isActive) {
      // Si nos acabamos de ir al Piano o la Batería, ¡Pausa!
      _detenerJuego();
    }
  }

  void _iniciarJuego() {
    _combo = 0; // Reiniciamos el combo al entrar
    _mensaje = "¡Escucha el ritmo!";
    _cronometro.reset();
    _cronometro.start();

    _metronomoVisual = Timer.periodic(Duration(milliseconds: msPorBeat), (
      timer,
    ) {
      _metronomoPlayer.stop();
      _metronomoPlayer.resume();

      if (mounted) {
        setState(() {
          _escala = 1.2;
        });
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) setState(() => _escala = 1.0);
        });
      }
    });
  }

  void _detenerJuego() {
    _cronometro.stop();
    _metronomoVisual?.cancel();
  }

  void _evaluarToque() {
    int tiempoActual = _cronometro.elapsedMilliseconds;
    int beatIdealMasCercano = ((tiempoActual / msPorBeat).round()) * msPorBeat;
    int margenDeError = (tiempoActual - beatIdealMasCercano).abs();

    setState(() {
      if (margenDeError <= 50) {
        _mensaje = "¡PERFECTO!";
        _colorMensaje = Colors.greenAccent;
        _combo++;
      } else if (margenDeError <= 150) {
        _mensaje = "¡BIEN!";
        _colorMensaje = Colors.orangeAccent;
        _combo++;
      } else {
        _mensaje = "¡FALLO!";
        _colorMensaje = Colors.redAccent;
        _combo = 0;
      }

      _escala = 0.9;
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) setState(() => _escala = 1.0);
      });
    });
  }

  @override
  void dispose() {
    _detenerJuego();
    _metronomoPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _evaluarToque(),
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "COMBO: $_combo",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50),

              AnimatedScale(
                scale: _escala,
                duration: const Duration(milliseconds: 100),
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurpleAccent.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.music_note,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 50),

              Text(
                _mensaje,
                style: TextStyle(
                  color: _colorMensaje,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  shadows: const [Shadow(color: Colors.black, blurRadius: 2)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
