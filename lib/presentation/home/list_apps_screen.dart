import 'package:app_usage/app_usage.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wenia_assignment/presentation/home/controller/home_controller.dart';

class ListAppsScreen extends StatelessWidget {
  ListAppsScreen({super.key});
  HomeController controller = Get.find();

  // Función para obtener el ícono de la aplicación
  Future<Widget> _getAppIcon(String packageName) async {
    Application? app = await DeviceApps.getApp(packageName, true);
    print(app);
    if (app is ApplicationWithIcon) {
      return Image.memory(app.icon, width: 40, height: 40);
    } else {
      return Icon(Icons.apps);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        itemCount: controller.listAppUsageInfo.length,
        itemBuilder: (context, index) {
          AppUsageInfo appInfo = controller.listAppUsageInfo[index];
          print(appInfo);

          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              leading: FutureBuilder<Widget>(
                future: _getAppIcon(appInfo.packageName), // Obtener el ícono
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return snapshot.data!;
                  } else {
                    return Icon(Icons.apps); // Ícono por defecto mientras carga
                  }
                },
              ),
              title: Text(appInfo.appName),
              subtitle:
                  Text('Tiempo de uso: ${appInfo.usage.inMinutes} minutos'),
            ),
          );
        },
      ),
    );
  }
}
