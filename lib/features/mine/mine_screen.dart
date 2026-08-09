import 'package:bears_video/common/widgets/app_vector_icon.dart';
import 'package:bears_video/core/services/episode_history_repository.dart';
import 'package:bears_video/common/widgets/app_bubble_notice.dart';
import 'package:bears_video/core/theme/app_colors.dart';
import 'package:bears_video/core/ui/responsive_layout.dart';
import 'package:bears_video/features/download/download_history_page.dart';
import 'package:bears_video/features/history/watch_history_page.dart';
import 'package:bears_video/features/mine/favorite_page.dart';
import 'package:bears_video/features/player/video_detail.dart';
import 'package:bears_video/features/shell/shell_providers.dart';
import 'package:bears_video/features/svg/bears_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class MineScreen extends HookConsumerWidget {
  const MineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(shellTabProvider);
    final refreshVersion = useState(0);
    final repository = useMemoized(EpisodeHistoryRepository.new);
    final historiesFuture = useMemoized(repository.getAllHistories, [
      currentTab,
      refreshVersion.value,
    ]);
    final isDesktop = ResponsiveLayout.isDesktop(context);

    Future<void> openPage(Widget page) async {
      await Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
      refreshVersion.value++;
    }

    void showPending(String feature) {
      showAppBubbleNotice(context, '$feature功能暂未开放');
    }

    return SafeArea(
      child: DecoratedBox(
        decoration: const BoxDecoration(color: AppColors.background),
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: _MineHeader()),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 18),
              sliver: SliverToBoxAdapter(
                child: _HistorySection(
                  historiesFuture: historiesFuture,
                  onViewAll: () => openPage(const WatchHistoryPage()),
                  onOpenHistory: (history) async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => VideoDetailPage(
                          videoId: history.videoId,
                          initialSourceIndex: history.sourceIndex,
                          initialEpisodeIndex: history.episodeIndex,
                        ),
                      ),
                    );
                    refreshVersion.value++;
                  },
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(18, 0, 18, isDesktop ? 32 : 130),
              sliver: SliverToBoxAdapter(
                child: _FeatureSection(
                  items: [
                    _FeatureItem(
                      icon: SvgPicture.string(BearsSVG.heartStarSVG),
                      label: '我的收藏',
                      onTap: () => openPage(const FavoritePage()),
                    ),
                    _FeatureItem(
                      icon: SvgPicture.string(BearsSVG.mineDownloadSVG),
                      label: '我的下载',
                      onTap: () => openPage(const DownloadHistoryPage()),
                    ),
                    _FeatureItem(
                      icon: SvgPicture.string(BearsSVG.shareSVG),
                      label: '分享APP',
                      onTap: () async {
                        await Clipboard.setData(
                          const ClipboardData(text: 'Bears Video'),
                        );
                        if (!context.mounted) return;
                        showAppBubbleNotice(
                          context,
                          '应用名称已复制，可分享给好友',
                          type: AppBubbleNoticeType.success,
                        );
                      },
                    ),
                    _FeatureItem(
                      icon: SvgPicture.string(BearsSVG.settingMessageSVG),
                      label: '系统消息',
                      onTap: () => showPending('系统消息'),
                    ),
                    _FeatureItem(
                      icon: SvgPicture.string(BearsSVG.settingSVG),
                      label: '设置',
                      onTap: () => showPending('设置'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MineHeader extends StatelessWidget {
  const _MineHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: EdgeInsets.fromLTRB(24, 0, 24, 12),
      alignment: Alignment.bottomLeft,
      // decoration: BoxDecoration(
      //   gradient: LinearGradient(
      //     begin: Alignment.topLeft,
      //     end: Alignment.bottomRight,
      //     colors: [
      //       AppColors.primary.withValues(alpha: 0.18),
      //       const Color(0xFFE9F2FF),
      //       AppColors.background,
      //     ],
      //     stops: const [0, 0.56, 1],
      //   ),
      // ),
      child: const Text(
        '我的',
        style: TextStyle(fontSize: 26, color: AppColors.ink),
      ),
    );
  }
}

class _HistorySection extends StatelessWidget {
  const _HistorySection({
    required this.historiesFuture,
    required this.onViewAll,
    required this.onOpenHistory,
  });

  final Future<List<EpisodeHistory>> historiesFuture;
  final VoidCallback onViewAll;
  final ValueChanged<EpisodeHistory> onOpenHistory;

  @override
  Widget build(BuildContext context) {
    return _MineCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(title: '观看历史', onTap: onViewAll),
          const SizedBox(height: 8),
          SizedBox(
            height: 105,
            child: FutureBuilder<List<EpisodeHistory>>(
              future: historiesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final histories = (snapshot.data ?? const []).take(5).toList();
                if (histories.isEmpty) {
                  return const Center(
                    child: Text(
                      '还没有观看记录',
                      style: TextStyle(color: AppColors.inkMuted),
                    ),
                  );
                }
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: histories.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final history = histories[index];
                    return _HistoryPreview(
                      history: history,
                      onTap: () => onOpenHistory(history),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryPreview extends StatelessWidget {
  const _HistoryPreview({required this.history, required this.onTap});

  final EpisodeHistory history;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 168 * 0.75,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 168 * 0.75,
                height: 94 * 0.8,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    history.videoPoster.isEmpty
                        ? const ColoredBox(
                            color: AppColors.surfaceMuted,
                            child: AppVectorIcon(AppVectorIcons.film),
                          )
                        : CachedNetworkImage(
                            imageUrl: history.videoPoster,
                            fit: BoxFit.cover,
                            placeholder: (_, _) =>
                                const ColoredBox(color: AppColors.surfaceMuted),
                            errorWidget: (_, _, _) => const ColoredBox(
                              color: AppColors.surfaceMuted,
                              child: AppVectorIcon(AppVectorIcons.imageOff),
                            ),
                          ),
                    Positioned(
                      right: 7,
                      bottom: 5,
                      child: Text(
                        _formatDuration(history.watchedPositionMs),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${history.videoTitle} ${history.episodeLabel}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: Color.fromARGB(255, 107, 107, 107),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureSection extends StatelessWidget {
  const _FeatureSection({required this.items});

  final List<_FeatureItem> items;

  @override
  Widget build(BuildContext context) {
    return _MineCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('常用功能', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: ResponsiveLayout.isDesktop(context) ? 5 : 4,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              mainAxisExtent: 82,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) => items[index],
          ),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final Widget icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 36,
            height: 36,
            // decoration: BoxDecoration(
            //   color: AppColors.primary.withValues(alpha: 0.09),
            //   borderRadius: BorderRadius.circular(17),
            // ),
            child: icon,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _MineCard extends StatelessWidget {
  const _MineCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Row(
        children: [
          Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
          const Text(
            '全部',
            style: TextStyle(color: AppColors.inkMuted, fontSize: 13),
          ),
          // const SizedBox(width: 2),
          const AppVectorIcon(
            AppVectorIcons.chevronRight,
            color: AppColors.inkMuted,
          ),
        ],
      ),
    );
  }
}

String _formatDuration(int milliseconds) {
  final duration = Duration(milliseconds: milliseconds);
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return hours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
}
