import 'package:flutter/material.dart';
import 'package:rifstage_mobile/Data/providers/audio_provider.dart';
import 'package:rifstage_mobile/UI/core/constants/app_colors.dart';
import 'package:provider/provider.dart';

class PlayerBar extends StatefulWidget {
  const PlayerBar({super.key});

  @override
  State<PlayerBar> createState() => _PlayerBarState();
}

class _PlayerBarState extends State<PlayerBar> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioProvider>(context);
    if (audioProvider.currentSong == null) return const SizedBox();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColorsDark.bottomBackground.withOpacity(0.95),
        border: const Border(top: BorderSide(color: Colors.grey, width: 0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Row(
              children: [
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_up,
                  color: AppColorsDark.yellow,
                  size: 26,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    audioProvider.currentSong?['title'] ?? 'No title',
                    style: const TextStyle(
                      color: AppColorsDark.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // شريط التقدم
          StreamBuilder<DurationState>(
            stream: audioProvider.durationStateStream,
            builder: (context, snapshot) {
              final state = snapshot.data ??
                  DurationState(position: Duration.zero, total: Duration.zero);
              return Slider(
                min: 0,
                max: state.total.inSeconds.toDouble(),
                value: state.position.inSeconds
                    .clamp(0, state.total.inSeconds)
                    .toDouble(),
                onChanged: (value) {
                  audioProvider.seekTo(Duration(seconds: value.toInt()));
                },
                activeColor: AppColorsDark.yellow,
                inactiveColor: Colors.grey,
              );
            },
          ),

          // لو الـ player مفتوح
          if (_isExpanded) ...[
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    audioProvider.currentSong?['cover_url'] ??
                        'https://via.placeholder.com/100',
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    audioProvider.currentSong?['artist'] ?? '',
                    style: const TextStyle(
                      color: AppColorsDark.white,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    audioProvider.isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    color: AppColorsDark.yellow,
                    size: 36,
                  ),
                  onPressed: audioProvider.togglePlayPause,
                ),
              ],
            ),
            const SizedBox(height: 8),

            // الوقت
            StreamBuilder<DurationState>(
              stream: audioProvider.durationStateStream,
              builder: (context, snapshot) {
                final state = snapshot.data ??
                    DurationState(
                        position: Duration.zero, total: Duration.zero);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatDuration(state.position),
                        style: const TextStyle(color: AppColorsDark.white)),
                    Text(_formatDuration(state.total),
                        style: const TextStyle(color: AppColorsDark.white)),
                  ],
                );
              },
            ),
            const SizedBox(height: 8),

            // الصوت
            Row(
              children: [
                const Icon(Icons.volume_down, color: AppColorsDark.yellow),
                Expanded(
                  child: Slider(
                    min: 0.0,
                    max: 1.0,
                    value: audioProvider.volume,
                    onChanged: (value) => audioProvider.setVolume(value),
                    activeColor: AppColorsDark.yellow,
                    inactiveColor: Colors.grey,
                  ),
                ),
                const Icon(Icons.volume_up, color: AppColorsDark.yellow),
              ],
            ),

            // أزرار التحكم
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    icon: const Icon(Icons.skip_previous,
                        color: AppColorsDark.yellow),
                    onPressed: audioProvider.previousSong),
                IconButton(
                    icon: const Icon(Icons.replay_10,
                        color: AppColorsDark.yellow),
                    onPressed: audioProvider.rewind10),
                IconButton(
                    icon: const Icon(Icons.forward_10,
                        color: AppColorsDark.yellow),
                    onPressed: audioProvider.forward10),
                IconButton(
                    icon: const Icon(Icons.skip_next,
                        color: AppColorsDark.yellow),
                    onPressed: audioProvider.nextSong),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
  