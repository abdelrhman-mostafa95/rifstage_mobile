import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rifstage_mobile/Data/providers/auth_provider.dart';
import 'package:rifstage_mobile/UI/core/widgets/home_screen_widgets/app_bar.dart';
import 'package:rifstage_mobile/UI/core/widgets/home_screen_widgets/bottom_navbar.dart';
import 'package:rifstage_mobile/UI/core/widgets/home_screen_widgets/player_bar.dart';
import 'package:rifstage_mobile/UI/screens/home/tabs/home_tab/home.dart';
import 'package:rifstage_mobile/UI/screens/home/tabs/music_tab/music.dart';
import 'package:rifstage_mobile/UI/screens/home/tabs/news_tab/news.dart';
import 'package:rifstage_mobile/UI/screens/home/tabs/videos_tab/videos.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  final List<Widget> tabs = const [
    HomeTab(),
    SongsTab(),
    NewsTab(),
    VideosTab(),
  ];

  final List<String> titles = const [
    "Home",
    "Music",
    "News",
    "Videos",
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthUserProvider>(context);
    final user = authProvider.user;

    // 🧩 أول حرف من الاسم أو الإيميل (كابيتل)
    final String userInitial = user?.userMetadata?['name'] != null
        ? user!.userMetadata!['name'][0].toString().toUpperCase()
        : (user?.email != null ? user!.email![0].toUpperCase() : 'U');

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
        appBar: CustomAppBar(
          userName: userInitial, // ✅ أول حرف من اسم المستخدم
          titlePage: titles[selectedIndex],
        ),
        bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: selectedIndex,
          onItemTapped: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
        ),
        body: Stack(
          children: [
            Positioned.fill(child: tabs[selectedIndex]),
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: PlayerBar(),
            ),
          ],
        ),
      ),
    );
  }
}
