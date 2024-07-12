import 'package:flutter/material.dart';
import 'package:wenia_assignment/core/theme/custom_colors.dart';

class Themes {
  final darkMode = ThemeData.dark().copyWith(
    // Define el color de fondo por defecto para la aplicación
    scaffoldBackgroundColor: CustomColors.background2,
    // Configura otros estilos de tema aquí
    primaryColor: CustomColors.background1,
    // Configura el texto por defecto para usar un color claro
    textTheme: TextTheme(
      displayLarge: TextStyle(color: Colors.white),
    ),
    // Configura el estilo de AppBar
    appBarTheme: AppBarTheme(
      color: Colors.black,
      toolbarTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    ),
    // Configura el color de los iconos
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
  );
}
