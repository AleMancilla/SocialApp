// To parse this JSON data, do
//
//     final coinsAssetsModel = coinsAssetsModelFromJson(jsonString);

import 'dart:convert';

CoinsAssetsModel coinsAssetsModelFromJson(String str) =>
    CoinsAssetsModel.fromJson(json.decode(str));

String coinsAssetsModelToJson(CoinsAssetsModel data) =>
    json.encode(data.toJson());

class CoinsAssetsModel {
  List<Coin>? listCoin;
  int? timestamp;

  CoinsAssetsModel({
    this.listCoin,
    this.timestamp,
  });

  factory CoinsAssetsModel.fromJson(Map<String, dynamic> json) =>
      CoinsAssetsModel(
        listCoin: json["data"] == null
            ? []
            : List<Coin>.from(json["data"]!.map((x) => Coin.fromJson(x))),
        timestamp: json["timestamp"],
      );

  Map<String, dynamic> toJson() => {
        "data": listCoin == null
            ? []
            : List<dynamic>.from(listCoin!.map((x) => x.toJson())),
        "timestamp": timestamp,
      };
}

class Coin {
  String? id;
  String? rank;
  String? symbol;
  String? name;
  String? supply;
  String? maxSupply;
  String? marketCapUsd;
  String? volumeUsd24Hr;
  String? priceUsd;
  String? changePercent24Hr;
  String? vwap24Hr;
  String? explorer;
  bool favorite;

  Coin({
    this.id,
    this.rank,
    this.symbol,
    this.name,
    this.supply,
    this.maxSupply,
    this.marketCapUsd,
    this.volumeUsd24Hr,
    this.priceUsd,
    this.changePercent24Hr,
    this.vwap24Hr,
    this.explorer,
    this.favorite = false,
  });

  factory Coin.fromJson(Map<String, dynamic> json) => Coin(
        id: json["id"],
        rank: json["rank"],
        symbol: json["symbol"],
        name: json["name"],
        supply: json["supply"],
        maxSupply: json["maxSupply"],
        marketCapUsd: json["marketCapUsd"],
        volumeUsd24Hr: json["volumeUsd24Hr"],
        priceUsd: json["priceUsd"],
        changePercent24Hr: json["changePercent24Hr"],
        vwap24Hr: json["vwap24Hr"],
        explorer: json["explorer"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "rank": rank,
        "symbol": symbol,
        "name": name,
        "supply": supply,
        "maxSupply": maxSupply,
        "marketCapUsd": marketCapUsd,
        "volumeUsd24Hr": volumeUsd24Hr,
        "priceUsd": priceUsd,
        "changePercent24Hr": changePercent24Hr,
        "vwap24Hr": vwap24Hr,
        "explorer": explorer,
      };
}
