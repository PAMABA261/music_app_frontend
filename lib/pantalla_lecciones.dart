import 'package:flutter/material.dart';
import 'pantalla_leccion_teoria.dart'; // 👈 Asegúrate de que el archivo se llame así

class PantallaLecciones extends StatelessWidget {
  const PantallaLecciones({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Academia Musical'),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.menu_book), text: 'Teoría'),
              Tab(icon: Icon(Icons.music_note), text: 'Práctica'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Pasamos el context a las listas para poder navegar
            _construirListaTeoria(context),
            _construirListaPractica(context),
          ],
        ),
      ),
    );
  }

  Widget _construirListaTeoria(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _elementoLeccion(
          context: context,
          titulo: 'Lección 1: El lenguaje del sonido',
          descripcion: '¿Qué es la música y cómo la percibimos?',
          esCompletada: true,
        ),
        _elementoLeccion(
          context: context,
          titulo: 'Lección 2: Las Notas Musicales',
          descripcion: 'Aprende las 7 notas y su posición en el piano.',
          esCompletada: false,
        ),
        _elementoLeccion(
          context: context,
          titulo: 'Lección 3: El Pentagrama',
          descripcion: 'Cómo leer las notas en las líneas y espacios.',
          esCompletada: false,
        ),
      ],
    );
  }

  Widget _construirListaPractica(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _elementoLeccion(
          context: context,
          titulo: 'Reto 1: Tu primera escala',
          descripcion: 'Toca de Do a Do sin equivocarte.',
          esCompletada: false,
          esPractica: true,
        ),
        _elementoLeccion(
          context: context,
          titulo: 'Reto 2: Ritmo básico 4/4',
          descripcion: 'Sigue el pulso de la batería con una nota.',
          esCompletada: false,
          esPractica: true,
        ),
      ],
    );
  }

  Widget _elementoLeccion({
    required BuildContext context, // 👈 Ahora recibimos el context
    required String titulo,
    required String descripcion,
    required bool esCompletada,
    bool esPractica = false,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        leading: CircleAvatar(
          backgroundColor: esPractica
              ? Colors.orange.shade100
              : Colors.teal.shade100,
          child: Icon(
            esPractica ? Icons.play_arrow : Icons.chrome_reader_mode,
            color: esPractica ? Colors.orange : Colors.teal,
          ),
        ),
        title: Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(descripcion),
        trailing: Icon(
          esCompletada ? Icons.check_circle : Icons.arrow_forward_ios,
          color: esCompletada ? Colors.green : Colors.grey,
        ),
        onTap: () {
          // 👇 LA NAVEGACIÓN REAL 👇
          if (!esPractica) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PantallaLeccionTeoria(
                  titulo: titulo,
                  contenido:
                      'Bienvenido a la lección sobre $titulo.\n\nAquí explicaremos todos los conceptos teóricos necesarios de forma sencilla. En la música, comprender estos fundamentos es clave para poder interpretar cualquier partitura con éxito. ¡Vamos a descubrirlo juntos!',
                ),
              ),
            );
          } else {
            // Cuando hagamos la pantalla de práctica, la conectaremos aquí
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('La práctica aún no está disponible 🚧'),
              ),
            );
          }
        },
      ),
    );
  }
}
