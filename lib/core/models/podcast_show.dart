class PodcastShow {
  final String id;
  final String title;
  final String host;
  final String episodeTitle;
  final String coverImage;
  final String category;
  final String duration;
  final String currentTime;
  final String subtitle;

  const PodcastShow({
    required this.id,
    required this.title,
    required this.host,
    required this.episodeTitle,
    required this.coverImage,
    required this.category,
    required this.duration,
    required this.currentTime,
    this.subtitle = '',
  });
}
