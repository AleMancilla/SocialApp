import 'package:app_usage/app_usage.dart';
import 'package:easy_permission_validator/easy_permission_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
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
    List<AppUsageInfo> _list = await getUsageStats();
    if (_list.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<List<AppUsageInfo>> getUsageStats() async {
    try {
      DateTime endDate = DateTime.now();
      DateTime startDate = endDate.subtract(Duration(hours: 1));
      List<AppUsageInfo> infoList =
          await AppUsage().getAppUsage(startDate, endDate);

      // setState(() => _infos = infoList);

      for (var info in infoList) {
        print(info.toString());
      }
      return (infoList);
    } on AppUsageException catch (exception) {
      print(' ====== > $exception');
      // throw exception;
      return [];
    }
  }
}
