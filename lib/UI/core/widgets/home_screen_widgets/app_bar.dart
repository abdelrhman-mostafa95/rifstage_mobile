import 'package:flutter/material.dart';
import 'package:rifstage_mobile/UI/core/constants/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final String titlePage;

  const CustomAppBar({
    super.key,
    required this.userName,
    required this.titlePage,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // حذف بيانات المستخدم

    // رجّع المستخدم لشاشة الـ Login
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final String firstLetter =
        userName.isNotEmpty ? userName[0].toUpperCase() : '?';

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PopupMenuButton<String>(
            color: AppColorsDark.bottomBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (value) {
              if (value == 'logout') {
                _logout(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.redAccent),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 20,
              child: Text(
                firstLetter,
                style: const TextStyle(
                  color: AppColorsDark.primaryBackground,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // عنوان الصفحة
          Text(
            titlePage,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColorsDark.white,
            ),
          ),

          const SizedBox(width: 40),
        ],
      ),
    );
  }
}
