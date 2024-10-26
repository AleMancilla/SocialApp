import 'package:device_apps/device_apps.dart';
import 'package:get/get.dart';
import 'package:usage_stats/usage_stats.dart';

class ListAppsController extends GetxController {
  var apps = <Application>[].obs;
  var filteredApps = <Application>[].obs;
  var appsSelectable = <String>[
    'com.zhiliaoapp.musically',
    'com.whatsapp',
    'com.facebook.katana',
    'com.facebook.orca',
    'com.instagram.android',
  ].obs;
  var appUsageStats = <String, Duration>{}.obs;

  // Tiempo máximo de uso para cada app en appsSelectable
  var maxUsageTime = <String, Duration>{}.obs;

  @override
  void onInit() {
    super.onInit();
    getInstalledApps();
    getUsageStats();
    setDefaultMaxUsageTime();
  }

  // Función para asignar un tiempo máximo por defecto para cada app en appsSelectable
  void setDefaultMaxUsageTime() {
    for (var app in appsSelectable) {
      maxUsageTime[app] = Duration(
          minutes: 30); // Por ejemplo, 1 hora como tiempo máximo predeterminado
    }
  }

  // Función para actualizar el tiempo máximo de una aplicación específica
  void updateMaxUsageTime(String packageName, Duration maxTime) {
    if (appsSelectable.contains(packageName)) {
      maxUsageTime[packageName] = maxTime;
    }
  }

  void filterApps(String query) {
    if (query.isEmpty) {
      filteredApps.value = apps;
    } else {
      filteredApps.value = apps
          .where(
              (app) => app.appName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  void selectApp(String package) {
    if (appsSelectable.contains(package)) {
      appsSelectable.remove(package);
      maxUsageTime.remove(package);
    } else {
      appsSelectable.add(package);
      maxUsageTime[package] = Duration(hours: 1); // Tiempo predeterminado
    }
    sortAppsByUsage();
  }

  Future<void> getInstalledApps() async {
    List<Application> installedApps = await DeviceApps.getInstalledApplications(
        includeAppIcons: true,
        onlyAppsWithLaunchIntent: false,
        includeSystemApps: false);

    apps.value = installedApps;
    filteredApps.value = installedApps;
    sortAppsByUsage();
  }

  Future<void> getUsagePermission() async {
    bool granted = await UsageStats.checkUsagePermission() ?? false;
    if (!granted) {
      await UsageStats.grantUsagePermission();
    }
  }

  Future<void> getUsageStats() async {
    bool granted = await UsageStats.checkUsagePermission() ?? false;
    if (!granted) {
      await getUsagePermission();
    }

    DateTime endDate = DateTime.now();
    DateTime startDate = DateTime(endDate.year, endDate.month,
        endDate.day); // Inicia desde las 00:00 de hoy

    try {
      List<UsageInfo> stats =
          await UsageStats.queryUsageStats(startDate, endDate);

      for (var stat in stats) {
        if (stat.packageName != null && stat.totalTimeInForeground != null) {
          if (appUsageStats[stat.packageName!] == null) {
            appUsageStats[stat.packageName!] =
                Duration(milliseconds: int.parse(stat.totalTimeInForeground!));
          } else {
            appUsageStats[stat.packageName!] =
                Duration(milliseconds: int.parse(stat.totalTimeInForeground!)) +
                    (appUsageStats[stat.packageName!] as Duration);
          }
        }
      }

      sortAppsByUsage();
    } catch (e) {
      print("Error obteniendo estadísticas de uso: $e");
    }
  }

  void sortAppsByUsage() {
    apps.sort((a, b) {
      bool isASelectable = appsSelectable.contains(a.packageName);
      bool isBSelectable = appsSelectable.contains(b.packageName);

      if (isASelectable && !isBSelectable) {
        return -1;
      } else if (!isASelectable && isBSelectable) {
        return 1;
      }

      final durationA = appUsageStats[a.packageName] ?? Duration();
      final durationB = appUsageStats[b.packageName] ?? Duration();
      return durationB.compareTo(durationA);
    });
  }

  String formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours} ${hours == 1 ? 'hora' : 'horas'} y ${minutes} ${minutes == 1 ? 'minuto' : 'minutos'}';
    } else {
      return '${minutes} ${minutes == 1 ? 'minuto' : 'minutos'}';
    }
  }
}
