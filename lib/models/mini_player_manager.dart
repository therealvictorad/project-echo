import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:math';
import '../models/song.dart';

/// 🎧 MiniPlayerManager
/// Handles playback, queue control, and state for Project Echo.
/// Uses just_audio for audio handling.
/// Includes shuffle + repeat modes and safe cleanup on dispose.
/// ⚠️ Replace print() with debugPrint() for cleaner Flutter logs.

class MiniPlayerManager extends ChangeNotifier {
  final List<Song> _songs = [];
  int _currentIndex = -1;
  late final AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  // 🔁 Shuffle + Repeat
  bool _isShuffle = false;
  bool _isRepeat = false;

  MiniPlayerManager() {
    _audioPlayer = AudioPlayer();

    // Listen to player streams
    _audioPlayer.positionStream.listen((pos) {
      _position = pos;
      notifyListeners();
    });

    _audioPlayer.durationStream.listen((dur) {
      _duration = dur ?? Duration.zero;
      notifyListeners();
    });

    _audioPlayer.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      notifyListeners();

      if (state.processingState == ProcessingState.completed) {
        if (_isRepeat) {
          _playCurrent();
        } else {
          nextSong();
        }
      }
    });
  }

  // ======= GETTERS =======
  AudioPlayer get player => _audioPlayer;
  Song? get currentSong =>
      (_currentIndex >= 0 && _currentIndex < _songs.length)
          ? _songs[_currentIndex]
          : null;

  bool get isPlaying => _isPlaying;
  Duration get position => _position;
  Duration get duration => _duration;

  List<Song> get songs => _songs;
  bool get isShuffle => _isShuffle;
  bool get isRepeat => _isRepeat;

  int getSongIndex(Song song) =>
      _songs.indexWhere((s) => s.title == song.title && s.artist == song.artist);

  // ======= PLAYBACK CONTROL =======
  void setSongs(List<Song> songs) {
    _songs
      ..clear()
      ..addAll(songs);
    notifyListeners();
  }

  Future<void> playSong(int index) async {
    if (index < 0 || index >= _songs.length) return;
    _currentIndex = index;
    await _playCurrent();
  }

  Future<void> _playCurrent() async {
    final song = _songs[_currentIndex];
    final url = song.filePath;

    if (url.isEmpty) {
      debugPrint('⚠️ Missing file path for ${song.title}');
      return;
    }

    try {
      if (url.startsWith('assets/')) {
        await _audioPlayer.setAsset(url);
      } else {
        await _audioPlayer.setUrl(url);
      }
      await _audioPlayer.play();
      _isPlaying = true;
    } catch (e) {
      debugPrint('Error loading audio: $e');
    }

    notifyListeners();
  }

  void togglePlayPause() {
    if (_currentIndex == -1) return;
    if (_audioPlayer.playing) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
    _isPlaying = _audioPlayer.playing;
    notifyListeners();
  }

  void stop() {
    _audioPlayer.stop();
    _isPlaying = false;
    notifyListeners();
  }

  void prevSong() {
    if (_songs.isEmpty) return;
    _currentIndex = _isShuffle
        ? Random().nextInt(_songs.length)
        : (_currentIndex - 1 + _songs.length) % _songs.length;
    _playCurrent();
  }

  void nextSong() {
    if (_songs.isEmpty) return;
    _currentIndex = _isShuffle
        ? Random().nextInt(_songs.length)
        : (_currentIndex + 1) % _songs.length;
    _playCurrent();
  }

  void seek(Duration position) => _audioPlayer.seek(position);

  // ======= TOGGLES =======
  void toggleShuffle() {
    _isShuffle = !_isShuffle;
    notifyListeners();
  }

  void toggleRepeat() {
    _isRepeat = !_isRepeat;
    notifyListeners();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
