import 'package:app_usage/app_usage.dart';
import 'package:easy_permission_validator/easy_permission_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:system_alert_window/system_alert_window.dart';

class StepsController extends GetxController {
  RxBool permisionUsageIsComplete = false.obs;
  RxBool permisionSuperPosicionComplete = false.obs;

  // @override
  // void onInit() async {
  //   super.onInit();
  // }

  askForSuperpositionPermision() async {
    bool? status = await SystemAlertWindow.checkPermissions();
    print(' ==== status == $status');
    if (!(status ?? false)) {
      SystemAlertWindow.requestPermissions();
    }
  }

  permisionUseApp(BuildContext context) async {
    final permissionValidator = EasyPermissionValidator(
      context: context,
      appName: 'Social Stop',
      appNameColor: Colors.red,
      cancelText: 'Cancelar',
      enableLocationMessage:
          'Debe habilitar los permisos necesarios para utilizar la App.',
      goToSettingsText: 'Ir a Configuraciones',
      permissionSettingsMessage:
          'Necesita habilitar los permisos necesarios para que la aplicación funcione correctamente',
    );
    var result = await permissionValidator.systemAlertWindow();
    if (result) {
      // Do something;
      permisionSuperPosicionComplete.value = result;
      print(result);
    }
  }

  Future<void> askForPermision() async {
    // permisionUsageIsComplete.value = await verifyPermisions();
    verifyPermisions().then(
      (value) {
        permisionUsageIsComplete.value = value;
      },
    );
    print(' - -------- ${permisionUsageIsComplete.value}');
  }

  Future<bool> verifyPermisions() async {
    print('--------6');
    List<AppUsageInfo> _list = await getUsageStats();
    print('--------7');
    if (_list.isNotEmpty) {
      print('--------8');
      return true;
    }
    print('--------9');
    return false;
  }

  Future<List<AppUsageInfo>> getUsageStats() async {
    try {
      print('--------1');
      DateTime endDate = DateTime.now();
      print('--------2');
      DateTime startDate = endDate.subtract(Duration(hours: 1));
      print('--------3');
      List<AppUsageInfo> infoList =
          await AppUsage().getAppUsage(startDate, endDate);
      print('--------4');

      // setState(() => _infos = infoList);

      for (var info in infoList) {
        print(info.toString());
      }
      print('--------5');
      return (infoList);
    } on AppUsageException catch (exception) {
      print(' ====== > $exception');
      // throw exception;
      return [];
    }
  }
}
