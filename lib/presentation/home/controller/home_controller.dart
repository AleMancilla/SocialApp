import 'package:app_usage/app_usage.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxList<AppUsageInfo> listAppUsageInfo = <AppUsageInfo>[].obs;
  @override
  void onInit() async {
    super.onInit();
    getUsageStats();
  }

  Future<void> getUsageStats() async {
    try {
      print('--------1');
      DateTime endDate = DateTime.now();
      print('--------2');
      DateTime startDate = endDate.subtract(Duration(hours: 24));
      print('--------3');
      List<AppUsageInfo> infoList =
          await AppUsage().getAppUsage(startDate, endDate);
      print('--------4');

      // setState(() => _infos = infoList);

      for (var info in infoList) {
        print(info.toString());
      }
      print('--------5');
      listAppUsageInfo.value = infoList;
      print(infoList);
    } on AppUsageException catch (exception) {
      print(' ====== > $exception');
      // throw exception;
    }
  }

  // Función para obtener el ícono de la aplicación
  Future<Widget> _getAppIcon(String packageName) async {
    Application? app = await DeviceApps.getApp(packageName, true);
    if (app is ApplicationWithIcon) {
      return Image.memory(app.icon, width: 40, height: 40);
    } else {
      return Icon(Icons.apps);
    }
  }
}
