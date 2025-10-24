import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:echo/models/offline_songs.dart';
import 'package:echo/models/song.dart';

// ignore_for_file: avoid_print

class SongService {
  // Jamendo public API test client_id
  static const String apiUrl =
      'https://api.jamendo.com/v3.0/tracks/?client_id=2f74f6fa&format=json&limit=20';

  static Future<List<Song>> fetchOnlineSongs() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['results'] as List<dynamic>;

        final songs = data.map((track) {
          return Song(
            title: track['name'] ?? 'Unknown',
            artist: track['artist_name'] ?? 'Unknown Artist',
            filePath: track['audio'] ?? '',
            albumArt: track['album_image'] ?? '',
            isOnline: true,
          );
        }).toList();

        print('✅ Fetched ${songs.length} live songs from Jamendo API');
        return songs;
      } else {
        print('API error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Failed to fetch API songs: $e');
      return [];
    }
  }

  static Future<List<Song>> getHybridPlaylist() async {
    final offline = offlineSongs;
    final online = await fetchOnlineSongs();
    return [...offline, ...online];
  }
}
