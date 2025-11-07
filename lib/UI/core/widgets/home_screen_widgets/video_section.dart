import 'package:flutter/material.dart';
import 'package:rifstage_mobile/UI/core/widgets/home_screen_widgets/video_card.dart';
import 'package:rifstage_mobile/UI/core/constants/app_colors.dart';
import 'package:rifstage_mobile/UI/screens/home/tabs/videos_tab/video_player_screen.dart';

class VideoSection extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> items;

  const VideoSection({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 العنوان وشريط اللون
        Row(
          children: [
            Container(
              height: 2,
              width: 40,
              color: AppColorsDark.yellow,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColorsDark.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 🔹 الفيديوهات
        ...items.map((video) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VideoPlayerScreen(video: video),
                  ),
                );
              },
              child: VideoCard(video: video), // ✅ استخدام الكارد الجاهز
            ),
          );
        }).toList(),
      ],
    );
  }
}
