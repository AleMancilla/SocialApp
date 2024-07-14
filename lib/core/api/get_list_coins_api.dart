import 'package:wenia_assignment/core/network/api_service.dart';
import 'package:wenia_assignment/data/datasource/models/coin_assets_model.dart';

class GetListCoinApi {
  static Future<List<Coin>?> call() async {
    try {
      final response = await ApiService.get(endpoint: 'v2/assets');
      try {
        List<Coin>? list = coinsAssetsModelFromJson(response).listCoin;
        return (list ?? []);
      } catch (e) {
        return [];
        // rethrow;
      }
    } catch (error) {
      return [];
      // rethrow;
    }
  }
}
