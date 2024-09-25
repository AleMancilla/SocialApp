import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'overlay_controller.dart';

class PrincipalOverlay extends StatelessWidget {
  PrincipalOverlay({Key? key}) : super(key: key);

  final OverlayController controller = Get.put(OverlayController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(() {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Is active: ${controller.isActive}'),
              MaterialButton(
                onPressed: () async {
                  await controller.toggleOverlay();
                },
                color: Colors.red[900],
                child: const Text('Show overlay',
                    style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 14),
              MaterialButton(
                onPressed: () async {
                  await controller.sendData();
                },
                color: Colors.red[900],
                child: const Text('Send data',
                    style: TextStyle(color: Colors.white)),
              ),
              MaterialButton(
                onPressed: () async {
                  await controller.updateOverlaySize();
                },
                color: Colors.red[900],
                child: const Text('Update overlay size',
                    style: TextStyle(color: Colors.white)),
              ),
              MaterialButton(
                onPressed: () async {
                  await controller.getOverlayPosition();
                },
                color: Colors.red[900],
                child: const Text('Get overlay position',
                    style: TextStyle(color: Colors.white)),
              ),
              Text('Current position: ${controller.overlayPosition}'),
            ],
          );
        }),
      ),
    );
  }
}
