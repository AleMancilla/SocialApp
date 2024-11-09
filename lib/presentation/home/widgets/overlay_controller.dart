import 'package:get/get.dart';
import 'package:overlay_pop_up/overlay_pop_up.dart';

class OverlayController extends GetxController {
  var isActive = false.obs;
  var overlayPosition = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkOverlayStatus();
  }

  Future<void> checkOverlayStatus() async {
    isActive.value = await OverlayPopUp.isActive();
  }

  Future<void> toggleOverlay() async {
    print(' -------- ');
    final permission = await OverlayPopUp.checkPermission();
    if (permission) {
      if (!isActive.value) {
        isActive.value = await OverlayPopUp.showOverlay(
          width: 550,
          height: 400,
          screenOrientation: ScreenOrientation.portrait,
          closeWhenTapBackButton: true,
          isDraggable: true,
        );
      } else {
        final result = await OverlayPopUp.closeOverlay();
        isActive.value = result != true;
      }
    } else {
      await OverlayPopUp.requestPermission();
      await checkOverlayStatus();
    }
  }

  Future<void> sendData() async {
    if (isActive.value) {
      await OverlayPopUp.sendToOverlay({'mssg': 'Hello from dart!'});
    }
  }

  Future<void> updateOverlaySize() async {
    if (isActive.value) {
      await OverlayPopUp.updateOverlaySize(width: 500, height: 500);
    }
  }

  Future<void> getOverlayPosition() async {
    if (isActive.value) {
      final position = await OverlayPopUp.getOverlayPosition();
      overlayPosition.value = position?['overlayPosition']?.toString() ?? '';
    }
  }
}
