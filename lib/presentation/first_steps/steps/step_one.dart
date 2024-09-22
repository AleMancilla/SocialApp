import 'package:flutter/material.dart';

class StepOne extends StatelessWidget {
  const StepOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Text('Permiso de uso requerido'),
          SizedBox(height: 20),
          Text(
              'Social Stop necesita permiso para el uso de la API para poder accerder a tu información de uso. Por favor selecciona dar permiso, luego selecciona Social Media de la lista de aplicaciones y habilita el permiso'),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              print(' ontap');
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.cyan,
              ),
              width: double.infinity,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Dar Permiso',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
