import 'package:bears_video/src/rust/api/bears_api.dart';
import 'package:bears_video/src/rust/models/episode.dart';

Future<String> resolveEpisodePlaybackUrl({
  required ApiService apiService,
  required PlaySource playSource,
  required int episodeIndex,
}) async {
  if (episodeIndex < 0 || episodeIndex >= playSource.episodes.length) {
    throw RangeError.index(episodeIndex, playSource.episodes, 'episodeIndex');
  }

  final episodeUrl = playSource.episodes[episodeIndex].url.trim();
  if (episodeUrl.isEmpty) throw StateError('播放地址为空');
  if (!playSource.needResolve) return episodeUrl;

  final parseApi = playSource.parseApi.trim();
  if (parseApi.isEmpty) throw StateError('播放源需要解析，但 parseApi 为空');
  final resolvedUrl = await apiService.fetchSpecifiedVideoUrl(
    resolveUrl: '$parseApi$episodeUrl',
    headers: playSource.headers,
  );
  if (resolvedUrl.trim().isEmpty) throw StateError('解析后的播放地址为空');
  return resolvedUrl;
}
