import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rifstage_mobile/Data/providers/audio_provider.dart';
import 'package:rifstage_mobile/Data/providers/home_provider.dart';
import 'package:rifstage_mobile/UI/core/widgets/home_screen_widgets/news_section.dart';
import 'package:rifstage_mobile/UI/core/widgets/home_screen_widgets/song_section.dart';
import 'package:rifstage_mobile/UI/core/widgets/home_screen_widgets/player_bar.dart';
import 'package:rifstage_mobile/UI/core/widgets/home_screen_widgets/video_section.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    if (!homeProvider.isInitialized) {
      homeProvider.fetchHomeContent();
      homeProvider.isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);

    if (homeProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SongSection(
                title: "Latest Songs",
                items: homeProvider.songs,
                onTap: (song) {
                  Provider.of<AudioProvider>(context, listen: false)
                      .playSong(song, playlist: homeProvider.songs);
                },
              ),
              const SizedBox(height: 20),
              VideoSection(
                title: "Latest Videos",
                items: homeProvider.videos,
              ),
              const SizedBox(height: 20),
              NewsSection(
                title: "Latest News",
                items: homeProvider.articles,
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ],
    );
  }
}
