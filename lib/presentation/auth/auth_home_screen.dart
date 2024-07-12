import 'package:flutter/material.dart';

class AuthHomeScreen extends StatelessWidget {
  const AuthHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size sizeScreen = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
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
          ],
        ),
      ),
    );
  }
}
