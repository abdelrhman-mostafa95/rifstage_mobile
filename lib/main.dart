import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rifstage_mobile/Data/providers/audio_provider.dart';
import 'package:rifstage_mobile/Data/providers/auth_provider.dart';
import 'package:rifstage_mobile/Data/providers/home_provider.dart';
import 'package:rifstage_mobile/UI/core/utils/supabase_client.dart';
import 'package:rifstage_mobile/UI/routes/routes.dart';
import 'package:rifstage_mobile/UI/screens/auth/login.dart';
import 'package:rifstage_mobile/UI/screens/auth/register.dart';
import 'package:rifstage_mobile/UI/screens/home/home_screen.dart';
import 'package:rifstage_mobile/UI/screens/splash%20&%20on_boarding%20screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSupabase();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthUserProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => AudioProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      routes: {
        SplashScreen.routeName: (_) => SplashScreen(),
        Login.routeName: (_) => Login(),
        Register.routeName: (_) => Register(),
        HomeScreen.routeName: (_) => HomeScreen()
      },
    );
  }
}
