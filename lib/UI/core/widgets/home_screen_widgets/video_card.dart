import 'package:flutter/material.dart';
import 'package:rifstage_mobile/UI/core/constants/app_colors.dart';

class VideoCard extends StatelessWidget {
  final Map<String, dynamic> video;

  const VideoCard({super.key, required this.video});

  String? _extractVideoId(String url) {
    final regExp = RegExp(r"(?:v=|\/)([0-9A-Za-z_-]{11}).*");
    final match = regExp.firstMatch(url);
    return match != null ? match.group(1) : null;
  }

  @override
  Widget build(BuildContext context) {
    final thumbnailUrl = video['thumbnail_url'] ??
        'https://img.youtube.com/vi/${_extractVideoId(video['youtube_url'] ?? '')}/hqdefault.jpg';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColorsDark.bottomBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🎥 صورة الفيديو
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                Image.network(
                  thumbnailUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 200,
                    color: Colors.grey[800],
                    child: const Icon(
                      Icons.broken_image,
                      color: Colors.white54,
                      size: 60,
                    ),
                  ),
                ),
                const Positioned.fill(
                  child: Center(
                    child: Icon(
                      Icons.play_circle_fill,
                      color: Colors.redAccent,
                      size: 60,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 📝 التفاصيل
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔸 العنوان
                Text(
                  video['title'] ?? 'Untitled',
                  style: const TextStyle(
                    color: AppColorsDark.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                // 🔸 الوصف
                if (video['description'] != null &&
                    (video['description'] as String).isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      video['description'],
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                const SizedBox(height: 8),

                // 🔸 الصف اللي فيه التفاصيل الصغيرة (المدة - المشاهدات - التاريخ)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (video['duration'] != null)
                      Row(
                        children: [
                          const Icon(Icons.timer,
                              color: Colors.white54, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            video['duration'],
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    if (video['views'] != null)
                      Row(
                        children: [
                          const Icon(Icons.visibility,
                              color: Colors.white54, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            "${video['views']} views",
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),

                const SizedBox(height: 6),

                // 🔸 التاريخ أو النص المخصص
                if (video['created_text'] != null)
                  Text(
                    video['created_text'],
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
