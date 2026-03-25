import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class PianoWidget extends StatefulWidget {
  const PianoWidget({super.key});

  @override
  State<PianoWidget> createState() => _PianoWidgetState();
}

class _PianoWidgetState extends State<PianoWidget> {
  String? currentNote;
  final ScrollController _scrollController = ScrollController();

  bool useEnglishNames = false;
  bool useFlats = false;
  bool _isInitialScrollDone = false;

  final Map<String, String> englishTranslation = {
    'Do': 'C',
    'Re': 'D',
    'Mi': 'E',
    'Fa': 'F',
    'Sol': 'G',
    'La': 'A',
    'Si': 'B',
  };
  final Map<String, String> flatLatinTranslation = {
    'Do#': 'Reb',
    'Re#': 'Mib',
    'Fa#': 'Solb',
    'Sol#': 'Lab',
    'La#': 'Sib',
  };
  final Map<String, String> flatEnglishTranslation = {
    'Do#': 'Db',
    'Re#': 'Eb',
    'Fa#': 'Gb',
    'Sol#': 'Ab',
    'La#': 'Bb',
  };
  final Map<String, String> sharpEnglishTranslation = {
    'Do#': 'C#',
    'Re#': 'D#',
    'Fa#': 'F#',
    'Sol#': 'G#',
    'La#': 'A#',
  };

  List<String> whiteNotes = [];
  Map<int, String> blackNotes = {};

  // 👇 1. NUESTRA PISCINA DE REPRODUCTORES (Solo 10 en lugar de 88)
  final List<AudioPlayer> _polyphonyPlayers = List.generate(
    10,
    (_) => AudioPlayer(),
  );
  int _currentPlayerIndex = 0;

  @override
  void initState() {
    super.initState();
    _generateKeyboard();
    // Ya no llamamos a _preloadPianoSounds() porque los creamos al vuelo
  }

  void _generateKeyboard() {
    whiteNotes.clear();
    blackNotes.clear();
    whiteNotes.add('La0');
    blackNotes[0] = 'La#0';
    whiteNotes.add('Si0');
    for (int i = 1; i <= 7; i++) {
      int w = whiteNotes.length;
      whiteNotes.addAll([
        'Do$i',
        'Re$i',
        'Mi$i',
        'Fa$i',
        'Sol$i',
        'La$i',
        'Si$i',
      ]);
      blackNotes[w] = 'Do#$i';
      blackNotes[w + 1] = 'Re#$i';
      blackNotes[w + 3] = 'Fa#$i';
      blackNotes[w + 4] = 'Sol#$i';
      blackNotes[w + 5] = 'La#$i';
    }
    whiteNotes.add('Do8');
  }

  // 👇 2. NUEVA FUNCIÓN PARA REPRODUCIR RECICLANDO REPRODUCTORES
  void _playPianoSound(String noteName) {
    if (currentNote == noteName) return;
    setState(() {
      currentNote = noteName;
    });

    // Averiguamos el nombre del archivo al momento
    bool isBlack = noteName.contains('#');
    String file = noteName.toLowerCase();
    if (isBlack) file = file.replaceAll('#', '_s');

    // Cogemos un reproductor libre, le ponemos el sonido y lo lanzamos
    final player = _polyphonyPlayers[_currentPlayerIndex];
    player.play(AssetSource('audio/$file.mp3'));

    // Pasamos al siguiente reproductor para la próxima nota (del 0 al 9 en bucle)
    _currentPlayerIndex = (_currentPlayerIndex + 1) % _polyphonyPlayers.length;
  }

  @override
  void dispose() {
    // 👇 3. Limpiamos solo los 10 reproductores
    for (var player in _polyphonyPlayers) {
      player.dispose();
    }
    _scrollController.dispose();
    super.dispose();
  }

  void _handlePianoTouch(
    Offset localPosition,
    double whiteKeyWidth,
    double blackKeyWidth,
    double blackKeyHeight,
  ) {
    final double x = localPosition.dx;
    final double y = localPosition.dy;

    if (y < blackKeyHeight) {
      for (var entry in blackNotes.entries) {
        int whiteIndex = entry.key;
        double blackKeyLeft =
            (whiteKeyWidth * (whiteIndex + 1)) - (blackKeyWidth / 2);
        double blackKeyRight = blackKeyLeft + blackKeyWidth;
        if (x >= blackKeyLeft && x <= blackKeyRight) {
          _playPianoSound(entry.value);
          return;
        }
      }
    }
    int whiteIndex = (x / whiteKeyWidth).floor();
    if (whiteIndex >= 0 && whiteIndex < whiteNotes.length) {
      _playPianoSound(whiteNotes[whiteIndex]);
    }
  }

  String _getDisplayText(String originalNote) {
    String baseName = originalNote.replaceAll(RegExp(r'[0-9]'), '');
    String octave = originalNote.replaceAll(RegExp(r'[^0-9]'), '');
    String displayName = baseName;

    if (baseName.contains('#')) {
      if (useEnglishNames) {
        displayName = useFlats
            ? flatEnglishTranslation[baseName]!
            : sharpEnglishTranslation[baseName]!;
      } else {
        displayName = useFlats ? flatLatinTranslation[baseName]! : baseName;
      }
    } else {
      displayName = useEnglishNames ? englishTranslation[baseName]! : baseName;
    }
    return '$displayName$octave';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Do/Re',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Switch(
                    value: useEnglishNames,
                    onChanged: (v) => setState(() => useEnglishNames = v),
                  ),
                  const Text(
                    'C/D',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '(#)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Switch(
                    activeThumbColor: Colors.deepPurple,
                    value: useFlats,
                    onChanged: (v) => setState(() => useFlats = v),
                  ),
                  const Text(
                    '(b)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double visibleWidth = constraints.maxWidth;
              final double whiteKeyWidth = visibleWidth / 14;
              final double totalPianoWidth = whiteKeyWidth * whiteNotes.length;
              final double height = constraints.maxHeight;
              final double blackKeyWidth = whiteKeyWidth * 0.65;
              final double blackKeyHeight = height * 0.55;

              if (!_isInitialScrollDone) {
                _isInitialScrollDone = true;
                // Calculamos el salto: 23 teclas blancas hasta llegar a Do4
                // Le restamos 1 o 2 teclas al cálculo si queremos que Do4 no quede pegado al borde izquierdo
                final double targetOffset = (23 - 1) * whiteKeyWidth;

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.jumpTo(targetOffset);
                  }
                });
              }

              return Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: SizedBox(
                    width: totalPianoWidth,
                    height: height,
                    child: GestureDetector(
                      onPanStart: (details) => _handlePianoTouch(
                        details.localPosition,
                        whiteKeyWidth,
                        blackKeyWidth,
                        blackKeyHeight,
                      ),
                      onPanUpdate: (details) => _handlePianoTouch(
                        details.localPosition,
                        whiteKeyWidth,
                        blackKeyWidth,
                        blackKeyHeight,
                      ),
                      onPanEnd: (_) {
                        setState(() {
                          currentNote = null;
                        });
                      },
                      child: Stack(
                        children: [
                          Row(
                            children: List.generate(whiteNotes.length, (index) {
                              bool isPressed = currentNote == whiteNotes[index];
                              return Container(
                                width: whiteKeyWidth,
                                decoration: BoxDecoration(
                                  color: isPressed
                                      ? Colors.grey[300]
                                      : Colors.white,
                                  border: Border.all(
                                    color: Colors.black87,
                                    width: 1,
                                  ),
                                  borderRadius: const BorderRadius.vertical(
                                    bottom: Radius.circular(5),
                                  ),
                                ),
                                alignment: Alignment.bottomCenter,
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Text(
                                  _getDisplayText(whiteNotes[index]),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              );
                            }),
                          ),
                          ...blackNotes.entries.map((entry) {
                            int whiteIndex = entry.key;
                            String noteName = entry.value;
                            bool isPressed = currentNote == noteName;
                            double leftPos =
                                (whiteKeyWidth * (whiteIndex + 1)) -
                                (blackKeyWidth / 2);
                            return Positioned(
                              left: leftPos,
                              top: 0,
                              width: blackKeyWidth,
                              height: blackKeyHeight,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isPressed
                                      ? Colors.grey[800]
                                      : Colors.black,
                                  borderRadius: const BorderRadius.vertical(
                                    bottom: Radius.circular(4),
                                  ),
                                ),
                                alignment: Alignment.bottomCenter,
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  _getDisplayText(noteName),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
