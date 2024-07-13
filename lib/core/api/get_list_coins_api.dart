import 'package:wenia_assignment/core/network/api_service.dart';
import 'package:wenia_assignment/data/datasource/models/coin_assets_model.dart';

class GetListCoinApi {
  static Future<List<Coin>?> call() async {
    final headers = {'Content-Type': 'application/json'};

    try {
      final response = await ApiService.get(endpoint: 'v2/assets');
      print(response);
      try {
        List<Coin>? list = coinsAssetsModelFromJson(response).listCoin;
        return (list ?? []);
      } catch (e) {
        return [];
        // rethrow;
      }
    } catch (error) {
      print('Error: $error');
      return [];
      // rethrow;
    }
  }
}
