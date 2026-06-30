import 'package:bears_video/core/models/media_item.dart';

class HomeSection {
  const HomeSection({required this.title, required this.items});

  final String title;
  final List<MediaItem> items;
}
