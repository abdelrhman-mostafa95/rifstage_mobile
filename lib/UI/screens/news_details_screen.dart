import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:rifstage_mobile/UI/core/constants/app_colors.dart';

class NewsDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> article;

  const NewsDetailsScreen({super.key, required this.article});

  bool _isArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    final title = article['title'] ?? '';
    final content = article['content'] ?? '';
    final coverImage = article['cover_image_url'];
    final isArabicText = _isArabic(title + content);

    return Scaffold(
      backgroundColor: AppColorsDark.primaryBackground,
      appBar: AppBar(
        title: Text(
          title.isNotEmpty ? title : 'Article',
          style: const TextStyle(color: AppColorsDark.white),
        ),
        backgroundColor: AppColorsDark.primaryBackground,
        foregroundColor: AppColorsDark.white,
        elevation: 0,
      ),
      body: Directionality(
        textDirection: isArabicText ? TextDirection.rtl : TextDirection.ltr,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🖼️ صورة الغلاف
              if (coverImage != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Image.network(
                      coverImage,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 180,
                        color: Colors.grey[800],
                        child: const Center(
                          child: Icon(Icons.image_not_supported,
                              size: 60, color: Colors.white54),
                        ),
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              // 📰 العنوان
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColorsDark.yellow, // لون مميز للعناوين
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 16),
              const Divider(color: Colors.white24, thickness: 1),

              // 📜 المحتوى
              Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColorsDark.bottomBackground,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Html(
                  data: content,
                  style: {
                    "body": Style(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: FontSize(16),
                      lineHeight: const LineHeight(1.7),
                      textAlign:
                          isArabicText ? TextAlign.right : TextAlign.left,
                      fontWeight: FontWeight.w400,
                      padding: HtmlPaddings.zero,
                    ),
                    "p": Style(
                      margin: Margins.symmetric(vertical: 8),
                    ),
                    "h1": Style(
                      color: AppColorsDark.yellow,
                      fontSize: FontSize(22),
                      fontWeight: FontWeight.bold,
                    ),
                    "h2": Style(
                      color: Colors.orangeAccent,
                      fontSize: FontSize(20),
                      fontWeight: FontWeight.w700,
                    ),
                    "a": Style(
                      color: Colors.lightBlueAccent,
                      textDecoration: TextDecoration.underline,
                    ),
                    "strong": Style(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
