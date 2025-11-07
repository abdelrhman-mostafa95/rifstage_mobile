import 'package:flutter/material.dart';
import 'package:rifstage_mobile/UI/core/constants/app_colors.dart';
import 'package:rifstage_mobile/UI/screens/home/tabs/music_tab/audio_player_screen.dart';
import 'package:rifstage_mobile/UI/screens/home/tabs/music_tab/playlist_details_screen.dart';
import 'package:rifstage_mobile/data/repositories/songs_repo.dart';

class SongsTab extends StatefulWidget {
  const SongsTab({super.key});

  @override
  State<SongsTab> createState() => _SongsTabState();
}

class _SongsTabState extends State<SongsTab> {
  final SongsRepository _repo = SongsRepository();
  bool isLoading = true;
  List<Map<String, dynamic>> songs = [];
  List<Map<String, dynamic>> playlists = [];

  @override
  void initState() {
    super.initState();
    _fetchSongsAndPlaylists();
  }

  Future<void> _fetchSongsAndPlaylists() async {
    try {
      final fetchedSongs = await _repo.getAllSongs();
      final fetchedPlaylists = await _repo.getAllPlaylists();

      setState(() {
        songs = fetchedSongs;
        playlists = fetchedPlaylists;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("❌ Error loading songs: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColorsDark.yellow),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🎵 All Songs
          const Text(
            "All Songs",
            style: TextStyle(
              color: AppColorsDark.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          ...songs.map((song) => ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    song['cover_url'] ?? '',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.music_note, color: Colors.white54),
                  ),
                ),
                title: Text(
                  song['title'] ?? 'Unknown Song',
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AudioPlayerScreen(
                        songs: songs,
                        initialIndex: songs.indexOf(song),
                      ),
                    ),
                  );
                },
              )),

          const SizedBox(height: 24),

          // 🎧 Playlists Section
          const Text(
            "Playlists",
            style: TextStyle(
              color: AppColorsDark.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          ...playlists.map((playlist) => GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlaylistDetailsScreen(playlist: playlist),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColorsDark.bottomBackground,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                        child: Image.network(
                          playlist['cover_url'] ?? '',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.library_music,
                            color: Colors.white54,
                            size: 60,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                playlist['title'] ?? 'Unknown Playlist',
                                style: const TextStyle(
                                  color: AppColorsDark.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                playlist['producer_name'] ?? '',
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
