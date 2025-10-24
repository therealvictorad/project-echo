class Song {
  final String title;
  final String artist;
  final String filePath; // path for local audio files
  final String? albumArt; // local image or URL
  final bool isOnline; // true = fetched from API, false = offline

  Song({
    required this.title,
    required this.artist,
    required this.filePath,
    this.albumArt,
    this.isOnline = false,
  });
}
