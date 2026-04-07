import 'package:flutter/material.dart';

class PantallaLeccionTeoria extends StatelessWidget {
  final String titulo;
  final String contenido;
  // En el futuro aquí podríamos pasar también la URL de una imagen o vídeo

  const PantallaLeccionTeoria({
    super.key,
    required this.titulo,
    required this.contenido,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(titulo),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TÍTULO PRINCIPAL
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 20),

            // ESPACIO PARA UNA IMAGEN ILUSTRATIVA (Placeholder)
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.teal.shade200, width: 2),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image, size: 50, color: Colors.teal),
                  SizedBox(height: 10),
                  Text(
                    'Aquí irá una imagen musical 🎵',
                    style: TextStyle(color: Colors.teal),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // CONTENIDO DE LA LECCIÓN (Texto)
            Text(
              contenido,
              style: const TextStyle(
                fontSize: 18,
                height: 1.6, // Interlineado para que sea fácil de leer
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 40),

            // BOTÓN DE COMPLETAR LECCIÓN
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Aquí conectaremos con FastAPI para guardar el progreso en la Base de Datos
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('¡Enhorabuena! Lección completada 🎉'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  // Volvemos a la pantalla anterior después de 1 segundo
                  Future.delayed(const Duration(seconds: 1), () {
                    if (context.mounted) Navigator.pop(context);
                  });
                },
                icon: const Icon(Icons.check_circle),
                label: const Text(
                  'Completar Lección',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
