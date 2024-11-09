// To parse this JSON data, do
//
//     final modelDbAllowedApps = modelDbAllowedAppsFromJson(jsonString);

import 'dart:convert';

List<ModelDbAllowedApps> modelDbAllowedAppsFromJson(String str) =>
    List<ModelDbAllowedApps>.from(
        json.decode(str).map((x) => ModelDbAllowedApps.fromJson(x)));

String modelDbAllowedAppsToJson(List<ModelDbAllowedApps> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelDbAllowedApps {
  int? appId;
  String? packageName;
  String? appName;
  dynamic userId;

  ModelDbAllowedApps({
    this.appId,
    this.packageName,
    this.appName,
    this.userId,
  });

  factory ModelDbAllowedApps.fromJson(Map<String, dynamic> json) =>
      ModelDbAllowedApps(
        appId: json["app_id"],
        packageName: json["package_name"],
        appName: json["app_name"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "app_id": appId,
        "package_name": packageName,
        "app_name": appName,
        "user_id": userId,
      };
}
