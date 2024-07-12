import 'package:flutter/material.dart';
import 'package:wenia_assignment/core/theme/custom_colors.dart';

class CustomTextFile extends StatefulWidget {
  CustomTextFile({
    super.key,
    required this.labelText,
    this.hintText,
    this.prefixIcon,
    this.controller,
    this.onChanged,
    this.maxLines,
    this.keyboardType,
    this.validation,
    this.isSecret = false,
    this.isCalendar = false,
  });

  String labelText;
  String? hintText;
  String? validation;
  Widget? prefixIcon;
  TextInputType? keyboardType;
  int? maxLines = 1;
  TextEditingController? controller;
  Function(String)? onChanged;

  bool isSecret;
  bool isCalendar;

  @override
  State<CustomTextFile> createState() => _CustomTextFileState();
}

class _CustomTextFileState extends State<CustomTextFile> {
  bool _obscureText =
      true; // Variable para controlar la visibilidad del texto de la contraseña

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        onChanged: widget.onChanged,
        onTap: widget.isCalendar ? () => _selectDate(context) : null,
        maxLines: !widget.isSecret ? widget.maxLines : 1,
        decoration: InputDecoration(
          labelText: widget.labelText,
          // floatingLabelBehavior: FloatingLabelBehavior.always,
          errorText: widget.validation ?? null,
          labelStyle: TextStyle(
              color: CustomColors.background3), // Color del texto del label
          hintText: widget
              .hintText, // Texto que se muestra cuando el TextField está vacío
          hintStyle: TextStyle(
              color: CustomColors.background3), // Color del texto de sugerencia
          prefixIcon: widget
              .prefixIcon, // Icono que se muestra antes del texto del input
          suffixIcon: getSufix(),
          // filled: true, // Indica si el TextField debe ser lleno de color

          errorBorder: OutlineInputBorder(
            // Bordes cuando hay un error
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.red, width: 2.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            // Bordes cuando hay un error y el TextField tiene foco
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.red, width: 2.0),
          ),
        ),
        readOnly: widget.isCalendar,
        obscureText: widget.isSecret
            ? _obscureText
            : false, // Indica si el texto debe mostrarse como texto oculto o no
      ),
    );
  }

  Widget? getSufix() {
    if (widget.isCalendar) {
      return Icon(Icons.calendar_today);
    }
    if (widget.isSecret) {
      return GestureDetector(
        onTap: () {
          setState(() {
            _obscureText =
                !_obscureText; // Cambia el estado de la visibilidad del texto
          });
        },
        child: Icon(
          _obscureText ? Icons.visibility : Icons.visibility_off,
          color: CustomColors.background3,
        ),
      );
    }
    return null;
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate;
    if (widget.controller?.text == '' || widget.controller?.text == null) {
      selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime(1990, 5, 15),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
      );
    } else {
      DateTime dateTime = DateTime.parse(widget.controller!.text);
      selectedDate = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
      );
    }

    if (selectedDate != null) {
      widget.controller?.text = "${selectedDate.toLocal()}".split(' ')[0];
    }
  }
}
