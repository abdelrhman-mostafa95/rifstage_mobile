import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class AudioProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();

  List<Map<String, dynamic>> _playlist = [];
  int _currentIndex = -1;

  bool isPlaying = false;

  AudioProvider() {
    // 🔁 متابعة حالة التشغيل مرة واحدة فقط
    _player.playerStateStream.listen((state) {
      isPlaying = state.playing;
      if (state.processingState == ProcessingState.completed) {
        nextSong(autoPlay: true);
      }
      notifyListeners();
    });
  }

  Map<String, dynamic>? get currentSong => (_playlist.isNotEmpty &&
          _currentIndex >= 0 &&
          _currentIndex < _playlist.length)
      ? _playlist[_currentIndex]
      : null;

  double get volume => _player.volume;

  Stream<DurationState> get durationStateStream =>
      Rx.combineLatest2<Duration, Duration?, DurationState>(
        _player.positionStream,
        _player.durationStream,
        (position, duration) =>
            DurationState(position: position, total: duration ?? Duration.zero),
      );

  void setPlaylist(List<Map<String, dynamic>> playlist, {int startIndex = 0}) {
    _playlist = playlist;
    _currentIndex = startIndex;
  }

  Future<void> playCurrentSong() async {
    if (_currentIndex < 0 || _currentIndex >= _playlist.length) return;

    final song = _playlist[_currentIndex];
    final url = song['audio_url'];
    if (url == null) return;

    try {
      await _player.setUrl(url);
      _player.play();
      isPlaying = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error playing song: $e');
    }
  }

  void playSong(Map<String, dynamic> song,
      {List<Map<String, dynamic>>? playlist}) {
    if (playlist != null) {
      setPlaylist(playlist, startIndex: playlist.indexOf(song));
    } else if (!_playlist.contains(song)) {
      _playlist.add(song);
      _currentIndex = _playlist.length - 1;
    } else {
      _currentIndex = _playlist.indexOf(song);
    }

    playCurrentSong();
  }

  void togglePlayPause() {
    if (isPlaying) {
      _player.pause();
    } else {
      _player.play();
    }
    notifyListeners();
  }

  void forward10() =>
      _player.seek(_player.position + const Duration(seconds: 10));

  void rewind10() =>
      _player.seek(_player.position - const Duration(seconds: 10));

  void nextSong({bool autoPlay = true}) {
    if (_playlist.isEmpty) return;

    _currentIndex = (_currentIndex + 1) % _playlist.length;
    if (autoPlay) playCurrentSong();
  }

  void previousSong() {
    if (_playlist.isEmpty) return;

    _currentIndex = (_currentIndex - 1 + _playlist.length) % _playlist.length;
    playCurrentSong();
  }

  void seekTo(Duration position) => _player.seek(position);

  // 🎚️ التحكم في الصوت
  void setVolume(double value) {
    _player.setVolume(value.clamp(0.0, 1.0));
    notifyListeners();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}

class DurationState {
  final Duration position;
  final Duration total;

  DurationState({required this.position, required this.total});
}
