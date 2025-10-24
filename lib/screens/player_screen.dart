import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/mini_player_manager.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  @override
  Widget build(BuildContext context) {
    final manager = context.watch<MiniPlayerManager>();
    final song = manager.currentSong;
    final player = manager.player;

    if (song == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF0B0B0B),
        body: Center(
          child: Text(
            'No song playing',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Now Playing',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Album Art
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 250,
                  width: 250,
                  color: const Color(0xFF1A1A1A),
                  child:(song.albumArt?.isNotEmpty ?? false)
                    ? Image.asset(song.albumArt!, fit: BoxFit.cover)
                    : Image.asset('assets/images/placeholder.jpg', fit: BoxFit.cover),

        ),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                song.title,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),

              // Artist
              Text(
                song.artist,
                style: GoogleFonts.poppins(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 24),

              // Progress bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: StreamBuilder<Duration>(
                  stream: player.positionStream,
                  builder: (context, snapshot) {
                    final position = snapshot.data ?? Duration.zero;
                    final total = player.duration ?? Duration.zero;
                    final clampedValue = total.inSeconds > 0
                        ? position.inSeconds.clamp(0, total.inSeconds).toDouble()
                        : 0.0;

                    return Column(
                      children: [
                        Slider(
                          min: 0,
                          max: total.inSeconds.toDouble(),
                          value: clampedValue,
                          onChanged: (val) {
                            player.seek(Duration(seconds: val.toInt()));
                          },
                          activeColor: Colors.greenAccent,
                          inactiveColor: Colors.white30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(position),
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                            Text(
                              _formatDuration(total),
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Shuffle + Repeat
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.shuffle,
                        color: manager.isShuffle ? Colors.greenAccent : Colors.white70,
                      ),
                      onPressed: manager.toggleShuffle,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.repeat,
                        color: manager.isRepeat ? Colors.greenAccent : Colors.white70,
                      ),
                      onPressed: manager.toggleRepeat,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Main Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 48,
                    color: Colors.white,
                    onPressed: manager.prevSong,
                    icon: const Icon(Icons.skip_previous),
                  ),
                  const SizedBox(width: 24),
                  IconButton(
                    iconSize: 64,
                    color: Colors.greenAccent,
                    onPressed: manager.togglePlayPause,
                    icon: Icon(
                      manager.isPlaying ? Icons.pause_circle : Icons.play_circle,
                    ),
                  ),
                  const SizedBox(width: 24),
                  IconButton(
                    iconSize: 48,
                    color: Colors.white,
                    onPressed: manager.nextSong,
                    icon: const Icon(Icons.skip_next),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}
