import 'package:flutter/material.dart';

class ScaffoldBackground extends StatelessWidget {
  ScaffoldBackground({super.key, required this.body});
  Widget body;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              // Degradado lineal
              gradient: LinearGradient(
                colors: [
                  Color(0xFF2c4047),
                  Color(0xFF5f2e32),
                ],
                begin: Alignment.centerLeft,
                stops: [
                  0.3,
                  0.7,
                ],
                end: Alignment.centerRight,
              ),
            ),
          ),
          Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              // Degradado lineal
              gradient: RadialGradient(
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black
                      .withOpacity(0.3), // Oscurece las esquinas (viñeta)
                ],
                center:
                    Alignment.center, // El degradado se centra en la pantalla
                radius: 1.2, // Controla la expansión del degradado
                stops: const [
                  0.1,
                  0.7,
                  1.2
                ], // Define los puntos de transición de los colores
              ),
            ),
          ),
          body,
        ],
      ),
    );
  }
}
