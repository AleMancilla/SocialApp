import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wenia_assignment/core/theme/custom_colors.dart';
import 'package:wenia_assignment/data/datasource/models/coin_assets_model.dart';
import 'package:wenia_assignment/presentation/home/controller/home_controller.dart';

class CriptoInfoScreen extends StatelessWidget {
  CriptoInfoScreen({super.key});
  HomeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Obx(() => Column(
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
                        flex: 7,
                        child: Text('Name'),
                      ),
                      Expanded(
                        flex: 4,
                        child: Text('Price'),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text('% 24h'),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(''),
                      ),
                    ],
                  ),
                  ...controller.filteredCoins.map((Coin coin) {
                    return TupleCoin(coin);
                  }).toList(),
                  // ...controller.listCoins.map((Coin coin) {
                  //   return TupleCoin(coin);
                  // }).toList(),
                ],
              )),
        ),
      ),
    );
  }
}

class TupleCoin extends StatelessWidget {
  TupleCoin(
    this.coin, {
    super.key,
  });
  Coin coin;
  HomeController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coin.symbol ?? '_',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  coin.name ?? '_',
                  style: TextStyle(
                    color: CustomColors.background3,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(getStringWithTwoDecimal(coin.priceUsd ?? '_')),
          ),
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: (coin.changePercent24Hr ?? '').contains('-')
                    ? CustomColors.accentColor1
                    : CustomColors.primary3,
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 5),
              margin: EdgeInsets.symmetric(vertical: 5),
              child: Text(
                '${getStringWithTwoDecimal(coin.changePercent24Hr ?? '_')} %',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  print('favorite');
                  // coin.favorite = !coin.favorite;
                  controller.addFavoriteCoin(coin);
                },
                child: Ink(
                  padding: EdgeInsets.all(5),
                  child: coin.favorite
                      ? Icon(
                          Icons.star,
                          color: Colors.red,
                        )
                      : Icon(
                          Icons.star_border,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                ),
              )),
        ],
      ),
    );
  }

  String getStringWithTwoDecimal(String number) {
    // Convertir el string a double
    double doubleValue = double.parse(number);

    // Formatear el número con 2 decimales
    String formattedValue = doubleValue.toStringAsFixed(2);

    // Imprimir el resultado
    return (formattedValue); // Salida: 58866.20
  }
}
