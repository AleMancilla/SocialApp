import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wenia_assignment/core/utils/custom_navigator.dart';
import 'package:wenia_assignment/core/utils/user_preferens.dart';
import 'package:wenia_assignment/presentation/auth/auth_home_screen.dart';
import 'package:wenia_assignment/presentation/home/controller/home_controller.dart';
import 'package:wenia_assignment/presentation/home/widgets/compare_prices_screen.dart';
import 'package:wenia_assignment/presentation/home/widgets/cripto_info_screen.dart';
import 'package:wenia_assignment/presentation/home/widgets/favorites_screen.dart';
import 'package:wenia_assignment/presentation/profile/edit_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final prefs = UserPreferences();
  HomeController controller = Get.put(HomeController());

  int _currentIndex = 0;

  final List<Widget> _screens = [
    CriptoInfoScreen(),
    FavoritesScreen(),
    ComparePricesScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // InkWell(
            //   onTap: () {
            //     prefs.deleteUserData();
            //     CustomNavigator.pushReplacement(context, AuthHomeScreen());
            //   },
            //   child: Text('LogOut'),
            // ),
            // InkWell(
            //   onTap: () {
            //     CustomNavigator.push(context, EditProfileScreen());
            //   },
            //   child: Padding(
            //     padding: const EdgeInsets.all(28.0),
            //     child: Text('editProfile'),
            //   ),
            // ),

            Expanded(child: _screens[_currentIndex]),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Criptos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.compare_arrows_rounded),
            label: 'VS',
          ),
        ],
      ),
    );
  }
}
