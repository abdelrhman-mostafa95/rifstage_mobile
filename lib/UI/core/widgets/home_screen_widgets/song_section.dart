import 'package:flutter/material.dart';
import 'package:rifstage_mobile/UI/core/widgets/home_screen_widgets/album_card.dart';
import 'package:rifstage_mobile/UI/core/constants/app_colors.dart';

class SongSection extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> items;
  final Function(Map<String, dynamic>)? onTap;

  const SongSection({
    super.key,
    required this.title,
    required this.items,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        ...items.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () => onTap?.call(item),
              child: AlbumCard(
                imageUrl:
                    item['cover_url'] ?? 'https://via.placeholder.com/150',
                title: item['title'] ?? 'No title',
                subtitle: item['artist'] ?? item['description'] ?? '',
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
