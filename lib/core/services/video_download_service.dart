import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:bears_video/core/services/episode_download_repository.dart';
import 'package:bears_video/core/services/playback_url_resolver.dart';
import 'package:bears_video/src/rust/api/bears_api.dart';
import 'package:bears_video/src/rust/models/episode.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

typedef DownloadProgress = void Function(double? progress);

class DownloadCancelledException implements Exception {
  const DownloadCancelledException();

  @override
  String toString() => '下载已取消';
}

class DownloadCancellationToken {
  final Set<void Function()> _listeners = {};
  bool _isCancelled = false;

  bool get isCancelled => _isCancelled;

  void cancel() {
    if (_isCancelled) return;
    _isCancelled = true;
    for (final listener in _listeners.toList()) {
      listener();
    }
    _listeners.clear();
  }

  void throwIfCancelled() {
    if (_isCancelled) throw const DownloadCancelledException();
  }

  void addListener(void Function() listener) {
    if (_isCancelled) {
      listener();
      return;
    }
    _listeners.add(listener);
  }

  void removeListener(void Function() listener) {
    _listeners.remove(listener);
  }
}

class VideoDownloadService {
  static const int _maxConcurrentDownloads = 4;
  static const int _minimumParallelBytes = 8 * 1024 * 1024;
  static const int _maxRetryAttempts = 3;

  final ApiService apiService;
  final EpisodeDownloadRepository repository;
  final HttpClient _client = HttpClient()
    ..connectionTimeout = const Duration(seconds: 20)
    ..maxConnectionsPerHost = _maxConcurrentDownloads + 1;

  VideoDownloadService({required this.apiService, required this.repository});

  void close() => _client.close(force: true);

  Future<EpisodeDownloadRecord> downloadEpisode({
    required int videoId,
    required String videoTitle,
    required String videoPoster,
    required String videoDetailJson,
    required PlaySource playSource,
    required int episodeIndex,
    DownloadCancellationToken? cancelToken,
    DownloadProgress? onProgress,
  }) async {
    cancelToken?.throwIfCancelled();
    if (episodeIndex < 0 || episodeIndex >= playSource.episodes.length) {
      throw RangeError.index(episodeIndex, playSource.episodes, 'episodeIndex');
    }
    final remoteUrl = await resolveEpisodePlaybackUrl(
      apiService: apiService,
      playSource: playSource,
      episodeIndex: episodeIndex,
    );
    cancelToken?.throwIfCancelled();
    final sourceName = playSource.name;
    final episodeLabel = playSource.episodes[episodeIndex].label;
    final headers = playSource.headers;
    final supportDirectory = await getApplicationSupportDirectory();
    final root = Directory(
      join(
        supportDirectory.path,
        'video_downloads',
        videoId.toString(),
        _safeName(sourceName),
        episodeIndex.toString(),
      ),
    );
    await _safeDeleteDirectory(root);
    await root.create(recursive: true);

    try {
      final uri = Uri.parse(remoteUrl);
      final localPath = await _download(
        uri,
        root,
        headers,
        cancelToken,
        onProgress,
      );
      cancelToken?.throwIfCancelled();
      final fileSizeBytes = await _directorySize(root, cancelToken);
      final record = EpisodeDownloadRecord(
        videoId: videoId,
        videoTitle: videoTitle,
        videoPoster: videoPoster,
        videoDetailJson: videoDetailJson,
        sourceName: sourceName,
        episodeIndex: episodeIndex,
        episodeLabel: episodeLabel,
        remoteUrl: remoteUrl,
        localPath: localPath,
        headers: headers,
        downloadedAt: DateTime.now().millisecondsSinceEpoch,
        fileSizeBytes: fileSizeBytes,
      );
      cancelToken?.throwIfCancelled();
      await repository.save(record);
      cancelToken?.throwIfCancelled();
      return record;
    } catch (_) {
      await repository.deleteRecord(
        videoId: videoId,
        sourceName: sourceName,
        episodeIndex: episodeIndex,
      );
      try {
        await _safeDeleteDirectory(root);
      } catch (_) {}
      rethrow;
    }
  }

  Future<String> _download(
    Uri uri,
    Directory root,
    Map<String, String> headers,
    DownloadCancellationToken? cancelToken,
    DownloadProgress? onProgress,
  ) async {
    cancelToken?.throwIfCancelled();
    final response = await _request(uri, headers, cancelToken: cancelToken);
    final contentType = response.headers.contentType?.mimeType ?? '';
    final isPlaylist =
        uri.path.toLowerCase().endsWith('.m3u8') ||
        contentType.contains('mpegurl');
    if (isPlaylist) {
      final body = await _readResponseText(response, cancelToken);
      return _downloadPlaylist(
        uri,
        body,
        root,
        headers,
        cancelToken,
        onProgress,
      );
    }

    final extension = extensionFromUri(uri, contentType);
    final file = File(join(root.path, 'video$extension'));
    final total = response.contentLength;
    final supportsRanges =
        response.headers
            .value(HttpHeaders.acceptRangesHeader)
            ?.toLowerCase()
            .contains('bytes') ??
        false;
    if (supportsRanges && total >= _minimumParallelBytes) {
      await _cancelResponse(response);
      try {
        return await _downloadInParts(
          uri,
          file,
          headers,
          total,
          cancelToken,
          onProgress,
        );
      } catch (error) {
        if (error is DownloadCancelledException ||
            cancelToken?.isCancelled == true) {
          rethrow;
        }
        onProgress?.call(null);
        if (await file.exists()) await file.delete();
        final fallbackResponse = await _request(
          uri,
          headers,
          cancelToken: cancelToken,
        );
        return _downloadSingleResponse(
          fallbackResponse,
          file,
          cancelToken,
          onProgress,
        );
      }
    }

    return _downloadSingleResponse(response, file, cancelToken, onProgress);
  }

  Future<String> _downloadSingleResponse(
    HttpClientResponse response,
    File file,
    DownloadCancellationToken? cancelToken,
    DownloadProgress? onProgress,
  ) async {
    final sink = file.openWrite();
    final total = response.contentLength;
    var received = 0;
    try {
      await _consumeResponse(response, cancelToken, (bytes) {
        sink.add(bytes);
        received += bytes.length;
        onProgress?.call(total > 0 ? received / total : null);
      });
    } finally {
      await sink.close();
    }
    cancelToken?.throwIfCancelled();
    onProgress?.call(1);
    return file.path;
  }

  Future<String> _downloadInParts(
    Uri uri,
    File file,
    Map<String, String> headers,
    int totalBytes,
    DownloadCancellationToken? cancelToken,
    DownloadProgress? onProgress,
  ) async {
    final partSize = (totalBytes / _maxConcurrentDownloads).ceil();
    final parts = <File>[];
    var receivedBytes = 0;

    Future<void> downloadPart(int index) async {
      cancelToken?.throwIfCancelled();
      final start = index * partSize;
      if (start >= totalBytes) return;
      final end = min(start + partSize - 1, totalBytes - 1);
      final part = File('${file.path}.part$index');
      parts.add(part);
      for (var attempt = 1; attempt <= _maxRetryAttempts; attempt++) {
        cancelToken?.throwIfCancelled();
        await _safeDeleteFile(part);
        var partBytes = 0;
        try {
          final response = await _request(
            uri,
            headers,
            cancelToken: cancelToken,
            rangeStart: start,
            rangeEnd: end,
          );
          if (response.statusCode != HttpStatus.partialContent) {
            await _cancelResponse(response);
            throw HttpException('服务器未返回分片内容', uri: uri);
          }

          final sink = part.openWrite();
          try {
            await _consumeResponse(response, cancelToken, (bytes) {
              sink.add(bytes);
              partBytes += bytes.length;
              receivedBytes += bytes.length;
              onProgress?.call(
                (receivedBytes / totalBytes).clamp(0.0, 1.0).toDouble(),
              );
            });
          } finally {
            await sink.close();
          }
          if (partBytes != end - start + 1) {
            throw HttpException('视频分片长度不完整', uri: uri);
          }
          return;
        } catch (error) {
          receivedBytes = max(0, receivedBytes - partBytes);
          await _safeDeleteFile(part);
          if (error is DownloadCancelledException ||
              cancelToken?.isCancelled == true ||
              attempt == _maxRetryAttempts) {
            rethrow;
          }
          await Future<void>.delayed(Duration(milliseconds: 500 * attempt));
        }
      }
    }

    try {
      await Future.wait(List.generate(_maxConcurrentDownloads, downloadPart));
      parts.sort((left, right) => left.path.compareTo(right.path));
      final output = file.openWrite();
      try {
        for (final part in parts) {
          cancelToken?.throwIfCancelled();
          await output.addStream(part.openRead());
        }
      } finally {
        await output.close();
      }
      onProgress?.call(1);
      return file.path;
    } finally {
      for (final part in parts) {
        await _safeDeleteFile(part);
      }
    }
  }

  Future<void> _cancelResponse(HttpClientResponse response) async {
    final subscription = response.listen((_) {});
    await subscription.cancel();
  }

  Future<String> _downloadPlaylist(
    Uri playlistUri,
    String playlist,
    Directory root,
    Map<String, String> headers,
    DownloadCancellationToken? cancelToken,
    DownloadProgress? onProgress,
  ) async {
    cancelToken?.throwIfCancelled();
    final lines = const LineSplitter().convert(playlist);
    final variants = <({int bandwidth, Uri uri})>[];
    for (var index = 0; index < lines.length - 1; index++) {
      if (!lines[index].startsWith('#EXT-X-STREAM-INF:')) continue;
      final match = RegExp(r'BANDWIDTH=(\d+)').firstMatch(lines[index]);
      variants.add((
        bandwidth: int.tryParse(match?.group(1) ?? '') ?? 0,
        uri: playlistUri.resolve(lines[index + 1].trim()),
      ));
    }
    if (variants.isNotEmpty) {
      variants.sort((a, b) => b.bandwidth.compareTo(a.bandwidth));
      final selected = variants.first.uri;
      final body = await _retry(() async {
        final response = await _request(
          selected,
          headers,
          cancelToken: cancelToken,
        );
        return _readResponseText(response, cancelToken);
      }, cancelToken);
      return _downloadPlaylist(
        selected,
        body,
        root,
        headers,
        cancelToken,
        onProgress,
      );
    }

    final resourceUris = <Uri>[];
    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;
      if (!trimmed.startsWith('#')) {
        resourceUris.add(playlistUri.resolve(trimmed));
      }
      for (final match in RegExp(r'URI="([^"]+)"').allMatches(trimmed)) {
        resourceUris.add(playlistUri.resolve(match.group(1)!));
      }
    }

    final uniqueResources = resourceUris.toSet().toList();
    final replacements = <String, String>{};
    var nextIndex = 0;
    var completed = 0;

    Future<void> worker() async {
      while (true) {
        cancelToken?.throwIfCancelled();
        final index = nextIndex;
        nextIndex++;
        if (index >= uniqueResources.length) return;

        final resourceUri = uniqueResources[index];
        final resourceName =
            'resource_${index.toString().padLeft(5, '0')}${extension(resourceUri.path)}';
        final file = File(join(root.path, resourceName));
        await _retry(() async {
          await _safeDeleteFile(file);
          final response = await _request(
            resourceUri,
            headers,
            cancelToken: cancelToken,
          );
          final sink = file.openWrite();
          try {
            await _consumeResponse(response, cancelToken, sink.add);
          } finally {
            await sink.close();
          }
        }, cancelToken);
        replacements[resourceUri.toString()] = resourceName;
        completed++;
        onProgress?.call(completed / uniqueResources.length);
      }
    }

    if (uniqueResources.isNotEmpty) {
      await Future.wait(
        List.generate(
          min(_maxConcurrentDownloads, uniqueResources.length),
          (_) => worker(),
        ),
      );
    }

    final rewritten = lines
        .map((line) {
          var result = line;
          for (final entry in replacements.entries) {
            final absolute = entry.key;
            result = result.replaceAll(absolute, entry.value);
            if (!line.startsWith('#')) {
              final resolved = playlistUri.resolve(line.trim()).toString();
              if (resolved == absolute) result = entry.value;
            } else {
              final uriMatch = RegExp(r'URI="([^"]+)"').firstMatch(line);
              if (uriMatch != null &&
                  playlistUri.resolve(uriMatch.group(1)!).toString() ==
                      absolute) {
                result = result.replaceFirst(uriMatch.group(1)!, entry.value);
              }
            }
          }
          return result;
        })
        .join('\n');
    final playlistFile = File(join(root.path, 'index.m3u8'));
    cancelToken?.throwIfCancelled();
    await playlistFile.writeAsString(rewritten);
    onProgress?.call(1);
    return playlistFile.path;
  }

  Future<HttpClientResponse> _request(
    Uri uri,
    Map<String, String> headers, {
    DownloadCancellationToken? cancelToken,
    int? rangeStart,
    int? rangeEnd,
  }) async {
    cancelToken?.throwIfCancelled();
    final request = await _client.getUrl(uri);
    void cancelRequest() => request.abort(const DownloadCancelledException());
    cancelToken?.addListener(cancelRequest);
    for (final entry in headers.entries) {
      request.headers.set(entry.key, entry.value);
    }
    if (rangeStart != null && rangeEnd != null) {
      request.headers.set(
        HttpHeaders.rangeHeader,
        'bytes=$rangeStart-$rangeEnd',
      );
      request.headers.set(HttpHeaders.acceptEncodingHeader, 'identity');
    }
    HttpClientResponse response;
    try {
      response = await request.close();
    } finally {
      cancelToken?.removeListener(cancelRequest);
    }
    cancelToken?.throwIfCancelled();
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw HttpException('下载请求失败: HTTP ${response.statusCode}', uri: uri);
    }
    return response;
  }

  String _safeName(String value) => value.replaceAll(RegExp(r'[^\w.-]+'), '_');

  String extensionFromUri(Uri uri, String contentType) {
    final value = extension(uri.path);
    if (value.isNotEmpty && value.length <= 8) return value;
    if (contentType.contains('mp4')) return '.mp4';
    return '.video';
  }

  Future<int> _directorySize(
    Directory directory,
    DownloadCancellationToken? cancelToken,
  ) async {
    var total = 0;
    await for (final entity in directory.list(recursive: true)) {
      cancelToken?.throwIfCancelled();
      if (entity is File) total += await entity.length();
    }
    return total;
  }

  Future<String> _readResponseText(
    HttpClientResponse response,
    DownloadCancellationToken? cancelToken,
  ) async {
    final bytes = BytesBuilder(copy: false);
    await _consumeResponse(response, cancelToken, bytes.add);
    return utf8.decode(bytes.takeBytes());
  }

  Future<void> _consumeResponse(
    HttpClientResponse response,
    DownloadCancellationToken? cancelToken,
    void Function(List<int> bytes) onData,
  ) async {
    cancelToken?.throwIfCancelled();
    final completer = Completer<void>();
    late StreamSubscription<List<int>> subscription;

    void completeError(Object error, [StackTrace? stackTrace]) {
      if (!completer.isCompleted) completer.completeError(error, stackTrace);
    }

    subscription = response.listen(
      (bytes) {
        if (completer.isCompleted) return;
        try {
          cancelToken?.throwIfCancelled();
          onData(bytes);
        } catch (error, stackTrace) {
          unawaited(subscription.cancel());
          completeError(error, stackTrace);
        }
      },
      onError: completeError,
      onDone: () {
        if (!completer.isCompleted) completer.complete();
      },
      cancelOnError: true,
    );

    void cancelSubscription() {
      unawaited(subscription.cancel());
      completeError(const DownloadCancelledException());
    }

    cancelToken?.addListener(cancelSubscription);
    try {
      await completer.future;
    } finally {
      cancelToken?.removeListener(cancelSubscription);
    }
  }

  Future<T> _retry<T>(
    Future<T> Function() operation,
    DownloadCancellationToken? cancelToken,
  ) async {
    for (var attempt = 1; attempt <= _maxRetryAttempts; attempt++) {
      cancelToken?.throwIfCancelled();
      try {
        return await operation();
      } catch (error) {
        if (error is DownloadCancelledException ||
            cancelToken?.isCancelled == true ||
            attempt == _maxRetryAttempts) {
          rethrow;
        }
        await Future<void>.delayed(Duration(milliseconds: 500 * attempt));
      }
    }
    throw StateError('下载重试状态异常');
  }

  Future<void> _safeDeleteDirectory(Directory directory) async {
    for (var attempt = 1; attempt <= _maxRetryAttempts; attempt++) {
      try {
        if (await directory.exists()) await directory.delete(recursive: true);
        return;
      } catch (_) {
        if (attempt == _maxRetryAttempts) rethrow;
        await Future<void>.delayed(Duration(milliseconds: 200 * attempt));
      }
    }
  }

  Future<void> _safeDeleteFile(File file) async {
    for (var attempt = 1; attempt <= _maxRetryAttempts; attempt++) {
      try {
        if (await file.exists()) await file.delete();
        return;
      } catch (_) {
        if (attempt == _maxRetryAttempts) rethrow;
        await Future<void>.delayed(Duration(milliseconds: 200 * attempt));
      }
    }
  }
}
