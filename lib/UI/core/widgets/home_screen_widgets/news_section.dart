import 'package:flutter/material.dart';
import 'package:rifstage_mobile/UI/core/constants/app_colors.dart';
import 'package:rifstage_mobile/UI/screens/news_details_screen.dart';

class NewsSection extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> items;

  const NewsSection({
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
        // 🔹 العنوان
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

        // 🔹 عرض الأخبار
        ...items.map((news) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NewsDetailsScreen(article: news),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColorsDark.bottomBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // ✅ صورة الكوفر
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                    child: Image.network(
                      news['cover_image_url'] ?? '',
                      height: 90,
                      width: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // ✅ عنوان الخبر
                  Expanded(
                    child: Text(
                      news['title'] ?? 'No title',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColorsDark.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
