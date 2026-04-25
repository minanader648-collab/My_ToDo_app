import 'package:flutter/material.dart';
import 'package:project_mobile_application/core/constants.dart';
import 'package:project_mobile_application/features/login_view/login_view.dart';
import 'package:hive/hive.dart';
import 'package:project_mobile_application/features/home_view/home_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      var sessionBox = Hive.box('sessionBox');
      bool isLoggedIn = sessionBox.containsKey('userName');

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => isLoggedIn ? const HomeView() : const LoginView(),
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primary,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/splash_logo.png",
                width: 250.0,
                height: 250.0,
              ),
              const Text(
                "My ToDo",
                style: TextStyle(
                  color: softPurple,
                  fontSize: 35.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Organize your day",
                style: TextStyle(
                  color: softPurple,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
