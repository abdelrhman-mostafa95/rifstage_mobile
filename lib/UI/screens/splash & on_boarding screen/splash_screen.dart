import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rifstage_mobile/Data/providers/auth_provider.dart';
import 'package:rifstage_mobile/UI/screens/auth/login.dart';
import 'package:rifstage_mobile/UI/screens/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "/";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;
  double _scale = 0.8;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  Future<void> _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      _opacity = 1.0;
      _scale = 1.0;
    });

    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _opacity = 0.0;
      _scale = 0.9;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    final authProvider = Provider.of<AuthUserProvider>(context, listen: false);

    // ✅ انتظر لحد ما يكمّل التحميل من SharedPreferences
    while (!authProvider.isInitialized) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    // ✅ بعد كده قرّر تروح فين
    if (authProvider.isLoggedIn) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Login()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF160f07),
            Colors.black,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: AnimatedOpacity(
            opacity: _opacity,
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
            child: AnimatedScale(
              scale: _scale,
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              child: Image.asset(
                'assets/images/rifstage-logo.png.png',
                width: 300,
                height: 200,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
