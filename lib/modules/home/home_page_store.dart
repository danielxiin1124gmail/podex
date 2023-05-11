import 'package:mobx/mobx.dart';

part 'home_page_store.g.dart';

class HomePageStore = _PokemonGridStoreBase with _$HomePageStore;

enum PanelType {
  FILTER_POKEMON_GENERATION,
  FILTER_POKEMON_TYPE,
  FILTER_POKEMON_NAME_NUMBER, // 这好像是指怪兽的纹字搜索浮窗
  FILTER_ITEMS, // 这好像是指物品的纹字搜索浮窗
  FAVORITES_POKEMONS,

  FILTER_TENNIS_ITEMS,

  FAVORITES_TENNIS_PLAYERS,
  FILTER_TENNIS_PLAYER_TYPE,
  FILTER_TENNIS_PLAYER_STYLE,
  FILTER_TENNIS_PLAYER_COUNTRY,
  FILTER_TENNIS_PLAYER_RIGHT_OR_LEFT,
  FILTER_TENNIS_PLAYER_BACKHAND_STYLE,
  FILTER_TENNIS_PLAYER_NAME_NUMBER,
  // 这里是透过 enum 来定义 PanelType 有上述五个常数 constants。
}

extension PanelTypeExtension on PanelType {
  bool get isTextFilter {
    return this == PanelType.FILTER_POKEMON_NAME_NUMBER ||
        this == PanelType.FILTER_TENNIS_PLAYER_NAME_NUMBER ||
        this == PanelType.FILTER_ITEMS ||
        this == PanelType.FILTER_TENNIS_ITEMS;
    // 就里就是单纯的确认，当前的 PanelType 是否是 TextFilter；当 this == PanelType.xxxxxx，
    // 即xxxxx 若是搜索框，那就 return True；否则 False。
  }
}

enum HomePageType {
  POKEMON_GRID,
  ITENS,
  TENNIS_ITEMS,
  TENNIS_PLAYER_GRID,
}

extension HomePageTypeExtension on HomePageType {
  String get description {
    switch (this) {
      case HomePageType.POKEMON_GRID:
        return "Pokemons!";
      case HomePageType.ITENS:
        return "Items";
      case HomePageType.TENNIS_PLAYER_GRID:
        return "Tennis Players";
      case HomePageType.TENNIS_ITEMS:
        return "Tennis Items";
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
  // 这里一改，首页马上便。改成 Items，首页立马变成 Items，都不需要重新制作 g.dart。

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
