import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:wenia_assignment/data/datasource/models/coin_assets_model.dart';
import 'package:wenia_assignment/presentation/home/controller/home_controller.dart';

class ComparePricesScreen extends StatelessWidget {
  ComparePricesScreen({super.key});
  HomeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Text(
              'Compare Prices',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Obx(() => Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          DropdownButton<Coin>(
                            isExpanded: true,
                            hint: Text('Select a Coin'),
                            value: controller.selectedLeftCoin.value.id != null
                                ? controller.selectedLeftCoin.value
                                : null,
                            items: controller.filteredCoins.map((Coin coin) {
                              return DropdownMenuItem<Coin>(
                                value: coin,
                                child: Text(coin.name ?? ''),
                              );
                            }).toList(),
                            onChanged: (Coin? newValue) {
                              controller.selectedLeftCoin.value = newValue!;
                            },
                          ),
                          Expanded(
                            child: controller.selectedLeftCoin.value.id != null
                                ? CoinDetails(controller.selectedLeftCoin.value)
                                : Center(
                                    child: Text('Select a coin to compare')),
                          ),
                        ],
                      ),
                    ),
                    VerticalDivider(),
                    Expanded(
                      child: Column(
                        children: [
                          DropdownButton<Coin>(
                            isExpanded: true,
                            hint: Text('Select a Coin'),
                            value: controller.selectedRightCoin.value.id != null
                                ? controller.selectedRightCoin.value
                                : null,
                            items: controller.filteredCoins.map((Coin coin) {
                              return DropdownMenuItem<Coin>(
                                value: coin,
                                child: Text(coin.name ?? ''),
                              );
                            }).toList(),
                            onChanged: (Coin? newValue) {
                              controller.selectedRightCoin.value = newValue!;
                            },
                          ),
                          Expanded(
                            child: controller.selectedRightCoin.value.id != null
                                ? CoinDetails(
                                    controller.selectedRightCoin.value)
                                : Center(
                                    child: Text('Select a coin to compare')),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

class CoinDetails extends StatelessWidget {
  final Coin coin;
  CoinDetails(this.coin);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Name: ${coin.name ?? '_'}'),
        SizedBox(height: 30),
        Text('Symbol: ${coin.symbol ?? '_'}'),
        SizedBox(height: 30),
        Text('Price: ${coin.priceUsd ?? '_'}'),
        SizedBox(height: 30),
        Text('Change % (24h): ${coin.changePercent24Hr ?? '_'}'),
        SizedBox(height: 30),
        Text('Max Suply: ${coin.maxSupply ?? '_'}'),
        SizedBox(height: 30),
        Text('Market cap: ${coin.marketCapUsd ?? '_'}'),
        // Agrega más detalles según sea necesario
      ],
    );
  }
}
