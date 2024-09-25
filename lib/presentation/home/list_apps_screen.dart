import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wenia_assignment/presentation/home/list_apps_controller.dart';

class ListAppsScreen extends StatelessWidget {
  final ListAppsController controller = Get.put(ListAppsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aplicaciones instaladas'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Obx(() {
          return ListView.builder(
            itemCount: controller.apps.length,
            itemBuilder: (context, index) {
              Application app = controller.apps[index];
              Duration? usageTime = controller.appUsageStats[app.packageName];

              return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 5,
                        spreadRadius: 2,
                        color: Colors.black12,
                      )
                    ]),
                margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                child: ListTile(
                  leading: app is ApplicationWithIcon
                      ? Image.memory(app.icon)
                      : Icon(Icons.android),
                  title: Text(app.appName),
                  subtitle: Text(
                    'Tiempo de uso: ${controller.formatDuration(usageTime ?? Duration())}',
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
