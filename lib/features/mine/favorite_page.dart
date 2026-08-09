import 'package:bears_video/common/widgets/app_vector_icon.dart';
import 'package:bears_video/core/services/video_favorite_repository.dart';
import 'package:bears_video/features/player/video_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final VideoFavoriteRepository _repository = VideoFavoriteRepository();
  late Future<List<VideoFavoriteRecord>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _favoritesFuture = _repository.getAll();
  }

  Future<void> _refresh() async {
    final future = _repository.getAll();
    setState(() {
      _favoritesFuture = future;
    });
    await future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leadingWidth: 46,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => Navigator.of(context).pop(),
              child: const SizedBox.square(
                dimension: 46,
                child: Center(
                  child: AppVectorIcon(AppVectorIcons.chevronLeft, size: 24),
                ),
              ),
            ),
          ),
        ),
        title: const Text('我的收藏', style: TextStyle(fontSize: 16)),
      ),
      body: FutureBuilder<List<VideoFavoriteRecord>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final favorites = snapshot.data ?? const [];
          if (favorites.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 100),
                  Center(
                    child: Image.asset(
                      'assets/images/empty_favorite.png',
                      width: 640,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const Center(
                    child: Text('当前还没有收藏过影视剧哦', style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      '收藏喜欢的影视剧，下次打开就能快速找到它们~',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
              itemCount: favorites.length,
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final favorite = favorites[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            VideoDetailPage(videoId: favorite.videoId),
                      ),
                    );
                    if (mounted) await _refresh();
                  },
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: SizedBox(
                          width: 142,
                          height: 82,
                          child: favorite.videoPoster.isEmpty
                              ? const ColoredBox(
                                  color: Color(0xFFE8E8E8),
                                  child: AppVectorIcon(AppVectorIcons.film),
                                )
                              : CachedNetworkImage(
                                  imageUrl: favorite.videoPoster,
                                  fit: BoxFit.cover,
                                  errorWidget: (_, _, _) => const ColoredBox(
                                    color: Color(0xFFE8E8E8),
                                    child: AppVectorIcon(
                                      AppVectorIcons.imageOff,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          favorite.videoTitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 17),
                        ),
                      ),
                      const AppVectorIcon(AppVectorIcons.chevronRight),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
