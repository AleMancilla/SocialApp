import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:wenia_assignment/core/theme/custom_colors.dart';
import 'package:wenia_assignment/presentation/auth/controller/auth_controller.dart';
import 'package:wenia_assignment/presentation/auth/widgets/login_form_section.dart';
import 'package:wenia_assignment/presentation/auth/widgets/signup_form_section.dart';
import 'package:wenia_assignment/presentation/widgets/custom_text_file.dart';

class AuthHomeScreen extends StatefulWidget {
  AuthHomeScreen({super.key});

  @override
  State<AuthHomeScreen> createState() => _AuthHomeScreenState();
}

class _AuthHomeScreenState extends State<AuthHomeScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  AuthController controller = Get.put(AuthController());
  int _selectedPage = 0;

  void _onPageChanged(int page) {
    setState(() {
      _selectedPage = page;
    });
  }

  void _onLoginTapped() {
    _pageController.animateToPage(0,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void _onSignupTapped() {
    _pageController.animateToPage(1,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    Size sizeScreen = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 40),
              alignment: Alignment.center,
              width: sizeScreen.width / 2,
              height: sizeScreen.width / 2,
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
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: _onLoginTapped,
                    child: AnimatedDefaultTextStyle(
                      duration: Duration(milliseconds: 300),
                      style: TextStyle(
                        fontSize: _selectedPage == 0 ? 24 : 20,
                        fontWeight: _selectedPage == 0
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: _selectedPage == 0
                            ? CustomColors.background3
                            : CustomColors.background1,
                      ),
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: _onSignupTapped,
                    child: AnimatedDefaultTextStyle(
                      duration: Duration(milliseconds: 300),
                      style: TextStyle(
                        fontSize: _selectedPage == 1 ? 24 : 20,
                        fontWeight: _selectedPage == 1
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: _selectedPage == 1
                            ? CustomColors.background3
                            : CustomColors.background1,
                      ),
                      child: Text(
                        'SIGNUP',
                        style: TextStyle(fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: PageView(
                onPageChanged: _onPageChanged,
                controller: _pageController,
                children: [
                  LoginFormSection(pageController: _pageController),
                  SignupFormSection(pageController: _pageController),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
