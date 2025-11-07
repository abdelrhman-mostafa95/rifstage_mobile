import 'package:supabase_flutter/supabase_flutter.dart';

class SongsRepository {
  final _client = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getAllSongs() async {
    final response = await _client
        .from('songs')
        .select()
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getAllPlaylists() async {
    final response = await _client
        .from('playlists')
        .select()
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getSongsByPlaylist(
      String playlistId) async {
    final response = await _client
        .from('playlist_songs')
        .select()
        .eq('playlist_id', playlistId);

    return List<Map<String, dynamic>>.from(response);
  }
}
