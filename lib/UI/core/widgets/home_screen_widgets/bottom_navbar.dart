import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rifstage_mobile/UI/core/constants/app_colors.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  final List<Map<String, dynamic>> items = const [
    {"icon": CupertinoIcons.house, "activeIcon": CupertinoIcons.house_fill},
    {
      "icon": CupertinoIcons.music_albums,
      "activeIcon": CupertinoIcons.music_albums_fill
    },
    {"icon": CupertinoIcons.news, "activeIcon": CupertinoIcons.news_solid},
    {
      "icon": CupertinoIcons.videocam_circle,
      "activeIcon": CupertinoIcons.videocam_circle_fill
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColorsDark.bottomBackground,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final isActive = widget.selectedIndex == index;
          final iconData =
              isActive ? items[index]['activeIcon'] : items[index]['icon'];

          return GestureDetector(
            onTap: () => widget.onItemTapped(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? AppColorsDark.white.withOpacity(0.2)
                    : Colors.transparent,
              ),
              child: Icon(
                iconData,
                color: isActive ? AppColorsDark.white : AppColorsDark.white,
                size: isActive ? 28 : 24,
              ),
            ),
          );
        }),
      ),
    );
  }
}
