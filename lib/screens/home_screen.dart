import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/mini_player_manager.dart';
import '../models/offline_songs.dart';
import '../models/song.dart';

/// 🏠 HomeScreen
/// Displays hybrid playlist (offline + asset songs) for Project Echo.
/// Uses Provider for MiniPlayer state management.
/// ⚠️ Requires Flutter 3.22+ for Color.withValues() API compatibility.

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final miniManager = Provider.of<MiniPlayerManager>(context, listen: false);

    // Hybrid playlist: offline + assets/audio tracks
    final List<Song> hybridSongs = [
      ...offlineSongs,
      Song(
        title: 'Track 1',
        artist: 'Unknown Artist',
        filePath: 'assets/audio/track1.mp3',
        albumArt: '', // no network URL
        isOnline: true,
      ),
      Song(
        title: 'Track 2',
        artist: 'Unknown Artist',
        filePath: 'assets/audio/track2.mp3',
        albumArt: '', // no network URL
        isOnline: true,
      ),
    ];

    void handleSongTap(List<Song> list, Song song) {
      final currentSong = miniManager.currentSong;

      if (!identical(miniManager.songs, list)) {
        miniManager.setSongs(list);
      }

      final index = list.indexOf(song);

      if (currentSong?.title != song.title) {
        miniManager.playSong(index);
      } else {
        miniManager.togglePlayPause();
      }
    }

    Widget buildSongCard(Song song, double width, List<Song> sourceList) {
      return GestureDetector(
        onTap: () => handleSongTap(sourceList, song),
        child: SizedBox(
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: width,
                width: width,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Image.asset(
                  'assets/images/placeholder.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                song.title,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                song.artist,
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Home',
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 20),
              Text('Recently Played',
                  style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 18,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 12),
              SizedBox(
                height: 180,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: hybridSongs.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    return buildSongCard(hybridSongs[index], 130, hybridSongs);
                  },
                ),
              ),
              const SizedBox(height: 30),
              Text('Popular Tracks',
                  style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 18,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: hybridSongs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final track = hybridSongs[index];
                    return GestureDetector(
                      onTap: () => handleSongTap(hybridSongs, track),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF141414),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 55,
                              height: 55,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A1A1A),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Image.asset(
                                'assets/images/placeholder.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    track.title,
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    track.artist,
                                    style: GoogleFonts.poppins(
                                        color: Colors.white70, fontSize: 12),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.more_vert, color: Colors.white70)
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
