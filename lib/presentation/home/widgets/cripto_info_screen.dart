import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wenia_assignment/data/datasource/models/coin_assets_model.dart';
import 'package:wenia_assignment/presentation/home/controller/home_controller.dart';
import 'package:wenia_assignment/presentation/home/widgets/list_of_coins_widget.dart';
import 'package:wenia_assignment/presentation/home/widgets/tuple_coin.dart';

class CriptoInfoScreen extends StatelessWidget {
  CriptoInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListOfCoinsWidget(),
        ),
      ),
    );
  }
}
