import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/mini_player_manager.dart';
import '../models/song.dart';


/// 🎵 LibraryScreen
/// Displays user's recently played, liked songs, and albums.
/// Uses TabBarView with Provider for MiniPlayer interaction.
/// ⚠️ Requires Flutter 3.22+ for Color.withValues() API compatibility.

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late final List<Song> recentlyPlayed;
  late final List<Song> likedSongs;
  late final List<Song> albums;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Convert your old map data into Song objects
    recentlyPlayed = [
      Song(title: 'Lost Frequencies', artist: 'Aether', filePath: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'),
      Song(title: 'Electric Pulse', artist: 'Nova', filePath: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3'),
    ];

    likedSongs = [
      Song(title: 'Midnight Echoes', artist: 'Eclipse', filePath: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3'),
      Song(title: 'Gravity Shift', artist: 'Synthara', filePath: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3'),
    ];

    albums = [
      Song(title: 'Neon Drift', artist: 'Kai Lumen', filePath: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3'),
      Song(title: 'Falling Stars', artist: 'Luma', filePath: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3'),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget buildSongList(List<Song> songs) {
    final miniManager = Provider.of<MiniPlayerManager>(context, listen: false);

    return ListView.separated(
      padding: const EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 80), // bottom padding for MiniPlayer
      itemCount: songs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final song = songs[index];

        return GestureDetector(
          onTap: () {
            if (!identical(miniManager.songs, songs)) {
              miniManager.setSongs(songs);
            }
            miniManager.playSong(index);
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF141414),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                // Cover art placeholder
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset('assets/images/placeholder.jpg', fit: BoxFit.cover),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        song.title,
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        song.artist,
                        style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text('Library'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.greenAccent,
          labelColor: Colors.greenAccent,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Recently Played'),
            Tab(text: 'Liked Songs'),
            Tab(text: 'Albums'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildSongList(recentlyPlayed),
          buildSongList(likedSongs),
          buildSongList(albums),
        ],
      ),
    );
  }
}
