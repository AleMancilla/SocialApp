import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wenia_assignment/core/theme/custom_colors.dart';
import 'package:wenia_assignment/presentation/home/controller/home_controller.dart';
import 'package:wenia_assignment/presentation/home/list_apps_controller.dart';

class ListAppsScreen extends StatefulWidget {
  @override
  State<ListAppsScreen> createState() => _ListAppsScreenState();
}

class _ListAppsScreenState extends State<ListAppsScreen> {
  final HomeController homecontroller = Get.put(HomeController());

  final ListAppsController listAppscontroller = Get.find();

  bool edit = false;

  @override
  Widget build(BuildContext context) {
    print(homecontroller.listAppUsageInfo);
    return Scaffold(
      appBar: AppBar(
        title: Text('Aplicaciones instaladas'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Obx(() {
          return Column(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Scrollbar(
                    thumbVisibility: true,
                    thickness: 5,
                    child: ListView.builder(
                      itemCount: listAppscontroller.filteredApps.length,
                      padding: EdgeInsets.all(0),
                      itemBuilder: (context, index) {
                        Application app =
                            listAppscontroller.filteredApps[index];
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
                                bottom: 5, left: 5, right: 5, top: 2),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              dense: true,
                              onTap: edit
                                  ? () {
                                      listAppscontroller
                                          .selectApp(app.packageName);
                                      setState(() {});
                                    }
                                  : null,
                              trailing: edit
                                  ? Icon(
                                      isSelected
                                          ? Icons.check_box
                                          : Icons.check_box_outline_blank,
                                      color: isSelected
                                          ? CustomColors.primary3
                                          : CustomColors.background3,
                                    )
                                  : null,
                              leading: app is ApplicationWithIcon
                                  ? Image.memory(
                                      app.icon,
                                      width: 40,
                                      height: 40,
                                    )
                                  : const Icon(Icons.android),
                              title: Text(app.appName),
                              subtitle: Text(
                                'Hoy lo usaste: ${listAppscontroller.formatDuration(usageTime ?? Duration())}',
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
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
