import 'package:flutter/material.dart';
import '/presentation/auth/auth_home_screen.dart';
import '/core/theme/custom_colors.dart';
import '/core/utils/custom_navigator.dart';
import '/core/utils/user_preferens.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;
  final prefs = UserPreferences();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller!, curve: Curves.easeIn);

    _controller!.forward();

    _loadDataAndNavigate();
  }

  Future<void> _loadDataAndNavigate() async {
    await Future.delayed(Duration(seconds: 5)); // Simula carga de datos
    // CustomNavigator.pushReplacement(context, InfiniteScreen());

    // print('prefs.userLogued ======> ${prefs.userLogued}');
    // if (!(prefs.userLogued == null || prefs.userLogued == false)) {
    //   if (!(prefs.userCurrentRol == null || prefs.userCurrentRol == 'null')) {
    //     CustomNavigator.pushReplacement(context, InfiniteScreen());
    //   } else {
    //     CustomNavigator.pushReplacement(context, CompleteInformationScreen());
    //   }
    // } else {
    CustomNavigator.pushReplacement(context, AuthHomeScreen());
    // }
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size sizeScreen = MediaQuery.of(context).size;
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: FadeTransition(
            opacity: _animation!,
            child: Center(
              child: Container(
                alignment: Alignment.center,
                width: sizeScreen.width / 1.5,
                height: sizeScreen.width / 1.5,
                child: Hero(
                  tag: 'imageSplash',
                  // child: SvgPicture.asset(
                  //   'assets/images/logo.png',
                  //   width: sizeScreen.width / 1.5,
                  //   height: sizeScreen.width / 1.5,
                  //   fit: BoxFit.contain,
                  // ),
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: sizeScreen.width / 1.2,
                    height: sizeScreen.width / 1.2,
                  ),
                ),
              ),
            ),
          ),
        ),
        Text('Assignment Wenia'),
        SizedBox(height: 40)
      ],
    ));
  }
}
