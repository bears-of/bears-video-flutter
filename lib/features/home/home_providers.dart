import 'dart:async';

import 'package:bears_video/core/di/injector.dart';
import 'package:bears_video/src/rust/api/bears_api.dart';
import 'package:bears_video/src/rust/models/recommend_video.dart';
import 'package:bears_video/src/rust/models/video_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeRecommendNotifier extends AsyncNotifier<HomeRecommendData> {
  @override
  FutureOr<HomeRecommendData> build() {
    final apiservice = sl.get<ApiService>();
    return apiservice.fetchHomeRecommend();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final apiservice = sl.get<ApiService>();
      return apiservice.fetchHomeRecommend();
    });
  }
}

final homeRecommendProvider =
    AsyncNotifierProvider<HomeRecommendNotifier, HomeRecommendData>(
      HomeRecommendNotifier.new,
    );

final homeSearchQueryProvider = StateProvider<String>((ref) => '');

final homeVideoListProvider =
    FutureProvider.family<List<VodListItem>, VideoListRequest>((ref, request) {
      return sl.get<ApiService>().fetchVideoList(req: request);
    });
