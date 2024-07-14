import 'package:get/get.dart';
import 'package:wenia_assignment/core/api/get_list_coins_api.dart';
import 'package:wenia_assignment/core/firebase_api/firestore/update_user_favorites_firestore.dart';
import 'package:wenia_assignment/core/utils/user_preferens.dart';
import 'package:wenia_assignment/core/utils/utils.dart';
import 'package:wenia_assignment/data/datasource/models/coin_assets_model.dart';

class HomeController extends GetxController {
  RxList<Coin> listCoins = <Coin>[].obs;
  var filteredCoins = <Coin>[].obs;
  var searchQuery = ''.obs;
  final prefs = UserPreferences();

  @override
  void onInit() async {
    super.onInit();
    await loadData();
    filteredCoins.value = listCoins; // Inicialmente, muestra todas las monedas
    refreshListFavorite();
  }

  Future loadData() async {
    listCoins.value = await GetListCoinApi.call() ?? [];
  }

  void filterCoins() {
    if (searchQuery.value.isEmpty) {
      filteredCoins.value = listCoins;
    } else {
      filteredCoins.value = listCoins
          .where((coin) =>
              coin.name!
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()) ||
              coin.symbol!
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()))
          .toList();
    }
  }

  Future addFavoriteCoin(Coin coin) async {
    List<String> listFavorite = prefs.userfavoriteCoinList ?? [];
    if (listFavorite.contains(coin.id)) {
      listFavorite.remove(coin.id);
    } else {
      listFavorite.add(coin.id!);
    }
    prefs.userfavoriteCoinList = listFavorite;
    await excecuteProcess(Get.context!, () async {
      await UpdateUserFavoritesFirestore.call(prefs.useruid!, listFavorite);
    });
    refreshListFavorite();
  }

  void refreshListFavorite() {
    List<String> listFavorite = prefs.userfavoriteCoinList ?? [];
    for (var coin in listCoins) {
      if (listFavorite.contains(coin.id)) {
        coin.favorite = true;
      } else {
        coin.favorite = false;
      }
    }
    for (var coin in filteredCoins) {
      if (listFavorite.contains(coin.id)) {
        coin.favorite = true;
      } else {
        coin.favorite = false;
      }
    }
    filteredCoins.refresh();
    listCoins.refresh();
  }
}
