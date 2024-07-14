import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wenia_assignment/data/datasource/models/coin_assets_model.dart';
import 'package:wenia_assignment/presentation/home/controller/home_controller.dart';
import 'package:wenia_assignment/presentation/home/widgets/tuple_coin.dart';

class ListOfCoinsWidget extends StatelessWidget {
  ListOfCoinsWidget({
    super.key,
    this.onlyFavorites = false,
  });

  HomeController controller = Get.find();
  bool onlyFavorites;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          TextField(
            onChanged: (value) {
              controller.searchQuery.value = value;
              controller.filterCoins();
            },
            decoration: InputDecoration(
              labelText: 'Search',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: GestureDetector(
                  onTap: () => controller.sortByName(),
                  child: Row(
                    children: [
                      Text('Name'),
                      Icon(Icons.sort),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: GestureDetector(
                  onTap: () => controller.sortByPrice(),
                  child: Row(
                    children: [
                      Text('Price'),
                      Icon(Icons.sort),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: GestureDetector(
                  onTap: () => controller.sortByChangePercent24Hr(),
                  child: Row(
                    children: [
                      Text('% 24h'),
                      Icon(Icons.sort),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(''),
              ),
            ],
          ),
          ...controller.filteredCoins.map((Coin coin) {
            if (!onlyFavorites) {
              return TupleCoin(coin);
            } else {
              if (coin.favorite) {
                return TupleCoin(coin);
              } else {
                return Container();
              }
            }
          }).toList(),
          // ...controller.listCoins.map((Coin coin) {
          //   return TupleCoin(coin);
          // }).toList(),
        ],
      ),
    );
  }
}
