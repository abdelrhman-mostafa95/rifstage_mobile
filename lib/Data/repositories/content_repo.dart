import 'package:supabase_flutter/supabase_flutter.dart';

class ContentRepository {
  final _client = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getSongs({int limit = 2}) async {
    final response = await _client
        .from('songs')
        .select()
        .order('created_at', ascending: false)
        .limit(limit);
    return response;
  }

  Future<List<Map<String, dynamic>>> getVideos({int limit = 2}) async {
    final response = await _client
        .from('videos')
        .select()
        .order('created_at', ascending: false)
        .limit(limit);
    return response;
  }

  Future<List<Map<String, dynamic>>> getNews({int limit = 2}) async {
    final response = await _client
        .from('news')
        .select()
        .order('created_at', ascending: false)
        .limit(limit);
    return response;
  }
}
