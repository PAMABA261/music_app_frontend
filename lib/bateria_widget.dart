import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class BateriaWidget extends StatefulWidget {
  const BateriaWidget({super.key});

  @override
  State<BateriaWidget> createState() => _BateriaWidgetState();
}

class _BateriaWidgetState extends State<BateriaWidget> {
  final List<Map<String, String>> drumPads = [
    {'name': 'Crash', 'file': 'crash'},
    {'name': 'Tom 1', 'file': 'tom1'},
    {'name': 'Hi-Hat', 'file': 'hihat'},
    {'name': 'Caja', 'file': 'caja'},
    {'name': 'Tom 2', 'file': 'tom2'},
    {'name': 'Bombo', 'file': 'bombo'},
  ];
  
  final Map<String, AudioPlayer> _drumPlayers = {};
  String? pressedDrum;

  @override
  void initState() {
    super.initState();
    _preloadDrumSounds();
  }

  void _preloadDrumSounds() {
    for (var pad in drumPads) {
      final player = AudioPlayer();
      player.setSource(AssetSource('audio/${pad['file']}.mp3'));
      _drumPlayers[pad['file']!] = player;
    }
  }

  void _playDrumSound(String fileName) {
    setState(() { pressedDrum = fileName; });
    final player = _drumPlayers[fileName];
    if (player != null) {
      player.stop();
      player.resume();
    }
  }

  @override
  void dispose() {
    for (var player in _drumPlayers.values) {
      player.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, 
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.2, 
        ),
        itemCount: drumPads.length,
        itemBuilder: (context, index) {
          final pad = drumPads[index];
          bool isPressed = pressedDrum == pad['file'];

          return GestureDetector(
            onTapDown: (_) => _playDrumSound(pad['file']!),
            onTapUp: (_) => setState(() => pressedDrum = null),
            onTapCancel: () => setState(() => pressedDrum = null),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              decoration: BoxDecoration(
                color: isPressed ? Colors.blue[300] : Colors.blueGrey[800],
                borderRadius: BorderRadius.circular(15),
                boxShadow: isPressed ? [] : [
                  const BoxShadow(color: Colors.black54, offset: Offset(2, 4), blurRadius: 4)
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                pad['name']!,
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }
}