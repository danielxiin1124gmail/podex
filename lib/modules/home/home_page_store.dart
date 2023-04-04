import 'package:mobx/mobx.dart';

part 'home_page_store.g.dart';

class HomePageStore = _PokemonGridStoreBase with _$HomePageStore;

enum PanelType {
  FILTER_POKEMON_GENERATION,
  FILTER_POKEMON_TYPE,
  FILTER_POKEMON_NAME_NUMBER, // 这好像是指怪兽的纹字搜索浮窗
  FILTER_ITEMS, // 这好像是指物品的纹字搜索浮窗
  FAVORITES_POKEMONS,
  // 这里是透过 enum 来定义 PanelType 有上述五个常数 constants。
}

extension PanelTypeExtension on PanelType {
  bool get isTextFilter {
    return this == PanelType.FILTER_POKEMON_NAME_NUMBER ||
        this == PanelType.FILTER_ITEMS;
    // 这里是在 PanelType上新增一个function，来确认 this (即PanelType) 是否等于
    // FILTER_POKEMON_NAME_NUMBER 或 FILTER_ITEMS；然后回复是或否。
  }
}

enum HomePageType {
  POKEMON_GRID,
  ITENS,
}

extension HomePageTypeExtension on HomePageType {
  String get description {
    switch (this) {
      case HomePageType.POKEMON_GRID:
        return "Pokemons!";
      case HomePageType.ITENS:
        return "Items";
      default:
        throw "Home Page Type not found";
    }
  }
  // 这就是创建一个 function，这 function 会return String。
  // 他用于确认 HomePageType 是 POKEMON_GRID or ITENS，然后回复相应文字标题。
  // 文字标题就是首页那颗一直旋转的球右边的文字标题。
}

abstract class _PokemonGridStoreBase with Store {
  @observable
  bool _isFilterOpen = false;

  @observable
  bool _isBackgroundBlack = false;

  @observable
  bool _isFabVisible = true;

  @observable
  PanelType? _panelType;

  @observable
  HomePageType _page = HomePageType.POKEMON_GRID;

  @computed
  bool get isFilterOpen => _isFilterOpen;

  @computed
  PanelType? get panelType => _panelType;

  @computed
  bool get isBackgroundBlack => _isBackgroundBlack;

  @computed
  bool get isFabVisible => _isFabVisible;

  @computed
  HomePageType get page => _page;

  @action
  void openFilter() {
    _isFilterOpen = true;
  }

  @action
  void closeFilter() {
    _isFilterOpen = false;
    _panelType = null;
  }

  @action
  void showBackgroundBlack() {
    _isBackgroundBlack = true;
  }

  @action
  void hideBackgroundBlack() {
    _isBackgroundBlack = false;
  }

  @action
  void showFloatActionButton() {
    _isFabVisible = true;
  }

  @action
  void hideFloatActionButton() {
    _isFabVisible = false;
  }

  @action
  void setPanelType(PanelType panelType) {
    _panelType = panelType;
  }

  @action
  void setPage(HomePageType page) {
    _page = page;
  }
}
