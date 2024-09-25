import 'package:device_apps/device_apps.dart';
import 'package:get/get.dart';
import 'package:usage_stats/usage_stats.dart';

class ListAppsController extends GetxController {
  var apps = <Application>[].obs;
  var appUsageStats = <String, Duration>{}.obs;

  @override
  void onInit() {
    super.onInit();
    getInstalledApps();
    getUsageStats();
  }

  Future<void> getInstalledApps() async {
    List<Application> installedApps = await DeviceApps.getInstalledApplications(
        includeAppIcons: true,
        onlyAppsWithLaunchIntent: false,
        includeSystemApps: false);

    apps.value = installedApps;
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
    DateTime startDate = endDate.subtract(Duration(days: 1));

    try {
      List<UsageInfo> stats =
          await UsageStats.queryUsageStats(startDate, endDate);

      for (var stat in stats) {
        print(
            ' ==== stat.packageName = ${stat.packageName} -- ${stat.totalTimeInForeground}');
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

      print(stats);

      sortAppsByUsage();
    } catch (e) {
      print("Error obteniendo estadísticas de uso: $e");
    }
  }

  void sortAppsByUsage() {
    apps.sort((a, b) {
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
