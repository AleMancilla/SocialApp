import 'package:get/get.dart';
import 'package:wenia_assignment/core/api/get_list_coins_api.dart';
import 'package:wenia_assignment/data/datasource/models/coin_assets_model.dart';

class HomeController extends GetxController {
  RxList<Coin> listCoins = <Coin>[].obs;
  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  loadData() async {
    listCoins.value = await GetListCoinApi.call() ?? [];
    print(listCoins);
  }
}
