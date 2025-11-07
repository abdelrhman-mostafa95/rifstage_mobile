import 'package:flutter/material.dart';
import 'package:rifstage_mobile/data/repositories/content_repo.dart';

class HomeProvider extends ChangeNotifier {
  final ContentRepository _repo = ContentRepository();

  List<Map<String, dynamic>> songs = [];
  List<Map<String, dynamic>> videos = [];
  List<Map<String, dynamic>> articles = [];
  bool isInitialized = false;

  bool isLoading = false;

  Future<void> fetchHomeContent() async {
    isLoading = true;
    notifyListeners();

    try {
      songs = await _repo.getSongs(limit: 2);
      videos = await _repo.getVideos(limit: 2);
      articles = await _repo.getNews(limit: 2);
    } catch (e) {
      debugPrint('Error loading home content: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
