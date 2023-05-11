import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:pokedex/shared/models/tennisItem.dart';
import 'package:pokedex/shared/repositories/tennisItem_repository.dart';
part 'tennisItem_store.g.dart';

class TennisItemStore = _tennisItemStoreBase with _$TennisItemStore;

abstract class _tennisItemStoreBase with Store {
  final TennisItemRepository _tennisItemRepository =
      GetIt.instance<TennisItemRepository>();

  @observable
  List<TennisItem> _tennisItems = [];

  @observable
  String? _filter;

  @computed
  String? get filter => _filter;

  @computed
  List<TennisItem> get tennisItems {
    if (_filter != null) {
      print('<tennisItem_store.dart> --> you just type something = $_filter');
      return _tennisItems
          .where((it) => it.name.toLowerCase().contains(_filter!.toLowerCase()))
          .toList();
      // 这边就是 get tennisItems，但要依据 filter的筛选结果。
    }

    return _tennisItems;
  }

  @action
  void setFilter(String filter) {
    this._filter = filter;
  }

  @action
  void clearFilter() {
    this._filter = null;
  }

  @action
  Future<void> fetchTennisItems() async {
    _tennisItems = await _tennisItemRepository.fetchTennisItems();
  }
}
