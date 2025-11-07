import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:rifstage_mobile/UI/core/constants/app_colors.dart';

class VideoPlayerScreen extends StatefulWidget {
  final Map<String, dynamic> video;

  const VideoPlayerScreen({super.key, required this.video});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    final videoId = _extractVideoId(widget.video['youtube_url'] ?? '');
    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: true,
      ),
    );
  }

  String? _extractVideoId(String url) {
    final regExp = RegExp(r"(?:v=|\/)([0-9A-Za-z_-]{11}).*");
    final match = regExp.firstMatch(url);
    return match != null ? match.group(1) : null;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _infoRow(String label, String? value, {IconData? icon}) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          if (icon != null) Icon(icon, color: Colors.white60, size: 18),
          if (icon != null) const SizedBox(width: 6),
          Text(
            "$label: ",
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white60),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final video = widget.video;

    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: AppColorsDark.yellow,
      ),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: AppColorsDark.primaryBackground,
          appBar: AppBar(
            title: Text(
              video['title'] ?? 'Video',
              style: const TextStyle(color: AppColorsDark.white),
            ),
            backgroundColor: AppColorsDark.primaryBackground,
            foregroundColor: AppColorsDark.white,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                player,

                // 🖼 الغلاف (لو متاح)
                if (video['thumbnail'] != null)
                  Container(
                    width: double.infinity,
                    height: 200,
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(video['thumbnail']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                // 📄 التفاصيل
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🧾 العنوان
                      Text(
                        video['title'] ?? '',
                        style: const TextStyle(
                          color: AppColorsDark.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // 📄 الوصف
                      if (video['description'] != null)
                        Text(
                          video['description'],
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            height: 1.4,
                          ),
                        ),

                      const SizedBox(height: 16),
                      const Divider(color: Colors.white24),

                      // ✅ بيانات الفيديو الإضافية
                      
                     
                      _infoRow("Duration", video['duration'],
                          icon: Icons.timer_outlined),
                      _infoRow("Views", video['views'], icon: Icons.visibility),
                      
                      _infoRow("Created At", video['created_text']),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
