import 'package:flutter/material.dart';
import 'package:wenia_assignment/presentation/home/widgets/list_of_coins_widget.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListOfCoinsWidget(
            onlyFavorites: true,
          ),
        ),
      ),
    );
  }
}
