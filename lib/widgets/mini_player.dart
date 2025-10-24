import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/mini_player_manager.dart';
import '../screens/player_screen.dart';


/// 🎧 MiniPlayer
/// Displays the currently playing song and controls.
/// ⚠️ Requires Flutter 3.22+ for Color.withValues() API compatibility.


class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MiniPlayerManager>(
      builder: (context, manager, child) {
        final song = manager.currentSong;
        if (song == null) return const SizedBox.shrink();

        return SafeArea(
          bottom: true,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PlayerScreen()),
              );
            },
            child: Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF141414),
                border: const Border(
                  top: BorderSide(color: Colors.greenAccent, width: 0.5),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 3,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Cover art placeholder
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      height: 50,
                      width: 50,
                      color: const Color(0xFF1A1A1A),
                      child:(manager.currentSong?.albumArt?.isNotEmpty ?? false)
                          ? Image.asset(
                        manager.currentSong!.albumArt!,
                        fit: BoxFit.cover,
                      )
                          : Image.asset('assets/images/placeholder.jpg', fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Song info
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song.title,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          song.artist,
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Controls
                  IconButton(
                    icon: const Icon(Icons.skip_previous, color: Colors.white),
                    onPressed: manager.prevSong,
                  ),
                  IconButton(
                    icon: Icon(
                      manager.isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                    ),
                    onPressed: manager.togglePlayPause,
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next, color: Colors.white),
                    onPressed: manager.nextSong,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
