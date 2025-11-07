import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:rifstage_mobile/Data/providers/audio_provider.dart';
import 'package:rifstage_mobile/UI/core/constants/app_colors.dart';

class AudioPlayerScreen extends StatefulWidget {
  final List<Map<String, dynamic>> songs;
  final int initialIndex;

  const AudioPlayerScreen({
    super.key,
    required this.songs,
    required this.initialIndex,
  });

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late AudioProvider audioProvider;

  @override
  void initState() {
    super.initState();

    // ⏯️ بعد ما الشاشة تفتح، نشغّل الأغنية المطلوبة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      audioProvider = Provider.of<AudioProvider>(context, listen: false);
      audioProvider.setPlaylist(widget.songs, startIndex: widget.initialIndex);
      audioProvider.playCurrentSong();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioProvider>(
      builder: (context, audio, _) {
        final currentSong = audio.currentSong;

        return Scaffold(
          backgroundColor: AppColorsDark.primaryBackground,
          appBar: AppBar(
            backgroundColor: AppColorsDark.primaryBackground,
            foregroundColor: AppColorsDark.white,
            title: Text(
              currentSong?['artist'] ?? 'Now Playing',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          body: currentSong == null
              ? const Center(
                  child: Text(
                    'No song playing',
                    style: TextStyle(color: Colors.white70),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 🖼 صورة الغلاف
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          currentSong['cover_url'] ?? '',
                          width: 250,
                          height: 250,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.music_note,
                            color: Colors.white54,
                            size: 120,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // 🎵 اسم الأغنية
                      Text(
                        currentSong['artist'] ?? 'Unknown Artist',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${currentSong['duration'] ?? ''} sec",
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 24),

                      // ⏳ شريط التقدم
                      StreamBuilder<DurationState>(
                        stream: audio.durationStateStream,
                        builder: (context, snapshot) {
                          final durationState = snapshot.data;
                          final position =
                              durationState?.position ?? Duration.zero;
                          final total = durationState?.total ?? Duration.zero;

                          return Column(
                            children: [
                              Slider(
                                activeColor: AppColorsDark.yellow,
                                inactiveColor: Colors.white24,
                                min: 0.0,
                                max: total.inMilliseconds.toDouble(),
                                value: position.inMilliseconds
                                    .clamp(0, total.inMilliseconds)
                                    .toDouble(),
                                onChanged: (value) {
                                  audio.seekTo(
                                      Duration(milliseconds: value.toInt()));
                                },
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _formatDuration(position),
                                    style:
                                        const TextStyle(color: Colors.white70),
                                  ),
                                  Text(
                                    _formatDuration(total),
                                    style:
                                        const TextStyle(color: Colors.white70),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // 🎛️ أزرار التحكم
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.skip_previous,
                                size: 40, color: Colors.white),
                            onPressed: audio.previousSong,
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: Icon(
                              audio.isPlaying
                                  ? Icons.pause_circle_filled
                                  : Icons.play_circle_fill,
                              size: 60,
                              color: AppColorsDark.yellow,
                            ),
                            onPressed: audio.togglePlayPause,
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: const Icon(Icons.skip_next,
                                size: 40, color: Colors.white),
                            onPressed: audio.nextSong,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // 🔊 الصوت
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.volume_down, color: Colors.white),
                          Slider(
                            activeColor: AppColorsDark.yellow,
                            inactiveColor: Colors.white24,
                            min: 0.0,
                            max: 1.0,
                            value: audio.volume,
                            onChanged: audio.setVolume,
                          ),
                          const Icon(Icons.volume_up, color: Colors.white),
                        ],
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
