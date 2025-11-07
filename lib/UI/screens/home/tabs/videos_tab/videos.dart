import 'package:flutter/material.dart';
import 'package:rifstage_mobile/UI/core/widgets/home_screen_widgets/video_card.dart';
import 'package:rifstage_mobile/UI/screens/home/tabs/videos_tab/video_player_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rifstage_mobile/UI/core/constants/app_colors.dart';

class VideosTab extends StatefulWidget {
  const VideosTab({super.key});

  @override
  State<VideosTab> createState() => _VideosTabState();
}

class _VideosTabState extends State<VideosTab> {
  final SupabaseClient supabase = Supabase.instance.client;
  bool isLoading = true;
  List<Map<String, dynamic>> videos = [];

  @override
  void initState() {
    super.initState();
    fetchVideos();
  }

  Future<void> fetchVideos() async {
    try {
      final response = await supabase.from('videos').select();
      setState(() {
        videos = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching videos: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColorsDark.yellow),
      );
    }

    if (videos.isEmpty) {
      return const Center(
        child: Text(
          "No videos available",
          style: TextStyle(color: AppColorsDark.white),
        ),
      );
    }

    return Container(
      color: AppColorsDark.primaryBackground,
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VideoPlayerScreen(video: video),
                ),
              );
            },
            child: VideoCard(video: video), // ✅ استخدام الكارد الجاهز
          );
        },
      ),
    );
  }
}
