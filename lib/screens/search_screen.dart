import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/mini_player_manager.dart';


/// 🔍 SearchScreen
/// Handles user music searches and interacts with MiniPlayerManager.
/// Filters songs by title or artist in real time.
/// ⚠️ Requires Flutter 3.22+ for Color.withValues() API compatibility.



class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final manager = context.watch<MiniPlayerManager>();
    final allSongs = manager.songs;

    // Filter global songs
    final filteredSongs = allSongs
        .where((song) =>
    song.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
        song.artist.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔍 Search Bar
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: TextField(
                  style: GoogleFonts.poppins(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search music...',
                    hintStyle: GoogleFonts.poppins(color: Colors.white54),
                    border: InputBorder.none,
                    filled: true,
                    fillColor: const Color(0xFF141414),
                    prefixIcon:
                    const Icon(Icons.search, color: Colors.greenAccent),
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onChanged: (value) =>
                      setState(() => searchQuery = value),
                ),
              ),

              // Results List
              Expanded(
                child: searchQuery.isEmpty
                    ? Center(
                  child: Text(
                    'Start typing to search 🔍',
                    style:
                    GoogleFonts.poppins(color: Colors.white54),
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.only(
                      bottom: 80, left: 8, right: 8),
                  itemCount: filteredSongs.length,
                  itemBuilder: (context, index) {
                    final song = filteredSongs[index];
                    return GestureDetector(
                      onTap: () {
                        final globalIndex =
                        manager.getSongIndex(song);
                        if (globalIndex != -1) {
                          manager.playSong(globalIndex);
                        }
                      },
                      child: Container(
                        margin:
                        const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF141414),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ListTile(
                          leading: Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius:
                              BorderRadius.circular(12),
                            ),
                            child: Image.asset(
                              'assets/images/placeholder.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            song.title,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            song.artist,
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          trailing: const Icon(Icons.more_vert,
                              color: Colors.white70),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
