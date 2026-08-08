import 'package:bears_video/core/di/injector.dart';
import 'package:bears_video/core/services/search_history_repository.dart';
import 'package:bears_video/src/rust/api/bears_api.dart';
import 'package:bears_video/src/rust/models/search_result.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final searchHistoryRepositoryProvider = Provider<SearchHistoryRepository>(
  (ref) => SearchHistoryRepository(),
);

final searchVodListProvider =
    FutureProvider.family<List<SearchVodItem>, SearchRequest>((ref, request) {
      return sl.get<ApiService>().search(req: request);
    });
