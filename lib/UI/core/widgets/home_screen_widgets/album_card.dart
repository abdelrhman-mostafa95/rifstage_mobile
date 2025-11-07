import 'package:flutter/material.dart';
import 'package:rifstage_mobile/UI/core/constants/app_colors.dart';

class AlbumCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;

  const AlbumCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            imageUrl,
            height: 120,
            width: double.infinity, 
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
              color: AppColorsDark.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Text(
          subtitle,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}
