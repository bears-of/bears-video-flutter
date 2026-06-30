import 'package:equatable/equatable.dart';

enum ProviderType { anime, movie }

class MediaItem extends Equatable {
  const MediaItem({
    required this.id,
    required this.title,
    this.englishTitle,
    this.cover,
    this.coverHeaders,
    required this.url,
    required this.type,
    required this.sourceId,
    this.subCount,
    this.dubCount,
    this.malId,
    this.tmdbId,
    this.tmdbIsTv = false,
    this.imdbId,
  });

  final String id;
  final String title;

  final String? englishTitle;
  final String? cover;
  final Map<String, String>? coverHeaders;
  final String url;
  final ProviderType type;
  final String sourceId;
  final int? subCount;
  final int? dubCount;

  final int? malId;
  final int? tmdbId;
  final bool tmdbIsTv;

  final String? imdbId;

  @override
  List<Object?> get props => [
    id,
    title,
    englishTitle,
    cover,
    coverHeaders,
    url,
    type,
    sourceId,
    subCount,
    dubCount,
    malId,
    tmdbId,
    tmdbIsTv,
    imdbId,
  ];
}
