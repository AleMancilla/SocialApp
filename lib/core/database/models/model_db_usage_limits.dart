// To parse this JSON data, do
//
//     final modelDbUsageLimits = modelDbUsageLimitsFromJson(jsonString);

import 'dart:convert';

List<ModelDbUsageLimits> modelDbUsageLimitsFromJson(String str) =>
    List<ModelDbUsageLimits>.from(
        json.decode(str).map((x) => ModelDbUsageLimits.fromJson(x)));

String modelDbUsageLimitsToJson(List<ModelDbUsageLimits> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelDbUsageLimits {
  int? limitId;
  String? packageName;
  int? userId;
  String? appId;
  String? dailyLimit;
  String? notificationInterval;

  ModelDbUsageLimits({
    this.limitId,
    this.packageName,
    this.userId,
    this.appId,
    this.dailyLimit,
    this.notificationInterval,
  });

  factory ModelDbUsageLimits.fromJson(Map<String, dynamic> json) =>
      ModelDbUsageLimits(
        limitId: json["limit_id"],
        packageName: json["package_name"],
        userId: json["user_id"],
        appId: json["app_id"],
        dailyLimit: json["daily_limit"],
        notificationInterval: json["notification_interval"],
      );

  Map<String, dynamic> toJson() => {
        "limit_id": limitId,
        "package_name": packageName,
        "user_id": userId,
        "app_id": appId,
        "daily_limit": dailyLimit,
        "notification_interval": notificationInterval,
      };
}
