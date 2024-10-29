import 'package:device_apps/device_apps.dart';
import 'package:get/get.dart';
import 'package:wenia_assignment/core/database/databaseservice.dart';
import 'package:wenia_assignment/core/database/models/model_db_allowed_apps.dart';

class ApiDatabase {
  static insertUser({required String name, required String email}) async {
    await DatabaseService.insertUser(name, email);
  }

  static insertAllowedApp(
      {required String package, required String name}) async {
    // await DatabaseService.insertAllowedApp('com.whatsapp', 'WhatsApp', null);
    ModelDbAllowedApps? previous = await getSpecificAllowedApps(package);
    if (previous == null) {
      await DatabaseService.insertAllowedApp(package, name, null);
    }
  }

  static insertAllowedAppList(List<Application> selectedApps) async {
    // await DatabaseService.insertAllowedApp('com.whatsapp', 'WhatsApp', null);

    List<ModelDbAllowedApps> listModelDbAllowedApps = await getAllowedApps();

    listModelDbAllowedApps.forEach(
      (element) {
        Application? application = selectedApps.firstWhereOrNull(
          (app) => app.packageName == element.packageName,
        );
        if (application == null) {
          DatabaseService.deleteAllowedApp(element.packageName!);
        }
      },
    );
    selectedApps.forEach(
      (element) async {
        ModelDbAllowedApps? previous =
            await getSpecificAllowedApps(element.packageName);
        if (previous == null) {
          await DatabaseService.insertAllowedApp(
              element.packageName, element.appName, null);
        }
      },
    );
  }

  static insertUsageLimit(
      {required String package,
      int dailyLimit = 120,
      int notificationInterval = 2}) async {
    ModelDbAllowedApps? data =
        await ApiDatabase.getSpecificAllowedApps(package);

    await DatabaseService.insertUsageLimit(
        1, data?.appId ?? 1, dailyLimit, notificationInterval);
  }

  static Future<List<Map<String, dynamic>>> getUsers() async {
    return await DatabaseService.getUsers();
  }

  static Future<List<ModelDbAllowedApps>> getAllowedApps() async {
    // return await DatabaseService.getAllowedApps();
    List<Map<String, dynamic>> response =
        await DatabaseService.getAllowedApps();

    List<ModelDbAllowedApps> listModelDbAllowedApps = response
        .map(
          (e) => ModelDbAllowedApps.fromJson(e),
        )
        .toList();

    return listModelDbAllowedApps;
  }

  static Future<ModelDbAllowedApps?> getSpecificAllowedApps(
      String package) async {
    // return await DatabaseService.getAllowedApps();
    List<Map<String, dynamic>> response =
        await DatabaseService.getAllowedApps();

    List<ModelDbAllowedApps> listModelDbAllowedApps = response
        .map(
          (e) => ModelDbAllowedApps.fromJson(e),
        )
        .toList();

    ModelDbAllowedApps? responseModelAllowed =
        listModelDbAllowedApps.firstWhereOrNull(
      (element) => package == element.packageName,
    );

    return responseModelAllowed;
  }

  static getUsageLimits() async {
    return await DatabaseService.getUsageLimits();
  }
}
