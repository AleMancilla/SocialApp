import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wenia_assignment/presentation/first_steps/steps/steps_controller.dart';
import 'package:wenia_assignment/presentation/home/list_apps_controller.dart';

class StepTree extends StatelessWidget {
  StepTree({super.key});
  StepsController controller = Get.find();
  final ListAppsController listAppscontroller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Obx(
        () {
          if (listAppscontroller.apps.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              Expanded(
                  child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Scrollbar(
                  thumbVisibility:
                      true, // Muestra siempre la barra de desplazamiento
                  thickness: 5,

                  child: ListView.builder(
                    itemCount: listAppscontroller.apps.length,
                    itemBuilder: (context, index) {
                      Application app = listAppscontroller.apps[index];
                      Duration? usageTime =
                          listAppscontroller.appUsageStats[app.packageName];

                      bool isSelected = listAppscontroller.appsSelectable
                          .contains(app.packageName);

                      return Opacity(
                        opacity: isSelected ? 1 : 0.5,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 5,
                                spreadRadius: 2,
                                color: Colors.black12,
                              ),
                            ],
                          ),
                          margin: const EdgeInsets.only(
                              bottom: 7, left: 5, right: 5, top: 3),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            // minVerticalPadding: 0,
                            onTap: () {
                              listAppscontroller.selectApp(app.packageName);
                            },

                            leading: app is ApplicationWithIcon
                                ? Image.memory(
                                    app.icon,
                                    width: 40,
                                    height: 40,
                                  )
                                : const Icon(Icons.android),
                            title: Text(app.appName),
                            subtitle: Text(
                              'Tiempo de uso: ${listAppscontroller.formatDuration(usageTime ?? Duration())}',
                              style: TextStyle(fontSize: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )),
              Text(
                'Principales redes sociales',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  fontFamily: 'paradice',
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Seleccione las principales redes sociales que usa, el objetivo sera mantener un control de tiempo en cada una de las redes sociales',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}
