import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rifstage_mobile/Data/providers/home_provider.dart';
import 'package:rifstage_mobile/UI/screens/auth/login.dart';
import 'package:rifstage_mobile/UI/screens/auth/register.dart';
import 'package:rifstage_mobile/UI/screens/home/home_screen.dart';
import 'package:rifstage_mobile/UI/screens/splash%20&%20on_boarding%20screen/splash_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const Login(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const Register(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
