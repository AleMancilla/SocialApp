import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wenia_assignment/presentation/common_widgets/custom_button.dart';
import 'package:wenia_assignment/presentation/first_steps/steps/steps_controller.dart';

class StepTwo extends StatelessWidget {
  StepTwo({super.key});
  StepsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Obx(
        () => Column(
          children: [
            Expanded(child: Container()),
            Text(
              'Permiso de superposicion',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                fontFamily: 'paradice',
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Social Stop necesita permiso para funciones como el temporizador flotante, bloqueo automatico de las aplicacionesm, alertas de uso, etc',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            controller.permisionSuperPosicionComplete.value
                ? CustomButton(
                    text: 'Permiso otorgado',
                    color: Colors.green,
                  )
                : CustomButton(
                    text: 'Dar permiso',
                    ontap: () async {
                      // await controller.askForSuperpositionPermision();
                      await controller.permisionUseApp(context);
                    },
                  ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
