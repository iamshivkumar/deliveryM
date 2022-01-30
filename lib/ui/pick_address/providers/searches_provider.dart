import '../../../core/models/debouncer.dart';
import '../../../core/models/search_result.dart';
import '../../../core/repositories/geo_repository_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final searchViewModelProvider = ChangeNotifierProvider<SearchViewModel>((ref) {
  final model = SearchViewModel(ref);
  model.init();
  return model;
});

class SearchViewModel extends ChangeNotifier {
  final Ref _ref;

  SearchViewModel(this._ref);
  GeoRepository get _repo => _ref.read(geoReposioryProvider);

  late Debouncer debouncer;

  void init() {
    debouncer = Debouncer(const Duration(milliseconds: 500), (v) async {
      if (v.length < 3) {
        if (results.isNotEmpty) {
          results = [];
        }
        return;
      }
      loading = true;
      results = await _repo.getSearchResults(v);
      loading = false;
    });
  }

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  List<SearchResult> _results = [];
  List<SearchResult> get results => _results;
  set results(List<SearchResult> results) {
    _results = results;
    notifyListeners();
  }
}
