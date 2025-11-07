import 'package:flutter/material.dart';
import 'package:rifstage_mobile/UI/core/constants/app_colors.dart';
import 'package:rifstage_mobile/UI/screens/home/tabs/music_tab/audio_player_screen.dart';
import 'package:rifstage_mobile/data/repositories/songs_repo.dart';

class PlaylistDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> playlist;

  const PlaylistDetailsScreen({super.key, required this.playlist});

  @override
  State<PlaylistDetailsScreen> createState() => _PlaylistDetailsScreenState();
}

class _PlaylistDetailsScreenState extends State<PlaylistDetailsScreen> {
  final SongsRepository _repo = SongsRepository();
  bool isLoading = true;
  List<Map<String, dynamic>> songs = [];

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    try {
      // 🔹 هنا بنجيب الأغاني من جدول playlist_songs فقط
      final fetched =
          await _repo.getSongsByPlaylist(widget.playlist['id'].toString());
      setState(() {
        songs = List<Map<String, dynamic>>.from(fetched);
        isLoading = false;
      });
    } catch (e) {
      debugPrint('❌ Error loading playlist songs: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final playlist = widget.playlist;

    return Scaffold(
      backgroundColor: AppColorsDark.primaryBackground,
      appBar: AppBar(
        title: Text(playlist['producer_name'] ?? 'Playlist'),
        backgroundColor: AppColorsDark.primaryBackground,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColorsDark.yellow),
            )
          : songs.isEmpty
              ? const Center(
                  child: Text(
                    "No songs in this playlist yet.",
                    style: TextStyle(color: Colors.white70),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: AppColorsDark.bottomBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            song['cover_url'] ?? '',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.music_note,
                              color: Colors.white54,
                            ),
                          ),
                        ),
                        title: Text(
                          song['artist'] ?? 'Unknown Artist',
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: Text(
                          song['created_at']?.toString().split('T').first ?? '',
                          style: const TextStyle(
                              color: Colors.white38, fontSize: 12),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AudioPlayerScreen(
                                songs: songs,
                                initialIndex: index,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
