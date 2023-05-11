import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:pokedex/shared/models/pokemon.dart';
import 'package:pokedex/shared/models/pokemon_filter.dart';
import 'package:pokedex/shared/models/pokemon_summary.dart';
import 'package:pokedex/shared/repositories/pokemon_repository.dart';

part 'pokemon_store.g.dart';

class PokemonStore = _PokemonStoreBase with _$PokemonStore;
// (B)_PokemonStoreBase 在下面定义了。
// (C)_$PokemonStore 这是 "flutter packages pub run build_runner build" 生成的。
// PokemonStore = B + C。

abstract class _PokemonStoreBase with Store {
  PokemonRepository _pokemonRepository = GetIt.instance<PokemonRepository>();
  // 他这一步是在 fetching Pokemon data。

  @observable
  PokemonFilter _pokemonFilter = PokemonFilter();
  // 这里是说，_pokemonFilter = PokemonFilter() 这个 class尔以；
  // 还不是 PokemonFilter() 里面的三个 filter 判断式的搜寻、筛选结果。还不是。

  @observable
  PokemonSummary? _pokemonSummary;
  // 每个小 pokemonsSummary 单体。

  @observable
  List<PokemonSummary>? _pokemonsSummary;
  // 每个小 pokemonsSummary 的list。

  @observable
  ObservableList<PokemonSummary> _favoritesPokemonsSummary = ObservableList();
  //----------------------------------------------------------------------
  @observable
  List<Pokemon> _pokemons = [];

  @observable
  Pokemon? _pokemon;
  //----------------------------------------------------------------------
  @computed
  PokemonFilter get pokemonFilter {
    print('<pokemon_store> @computed1 get pokemonFilter >');
    return _pokemonFilter;
  }

  @computed
  PokemonSummary? get pokemonSummary {
    print('<pokemon_store> @computed2 get pokemonSummary >');
    return _pokemonSummary;
  }
  // 中间没有s，pokemonSummary。

  @computed
  List<PokemonSummary>? get pokemonsSummary {
    return _pokemonFilter.filter(_pokemonsSummary);
  }
  // 中间有s，pokemonsSummary。
  // 这里其实就是首页"Pokemons"的数据。filter以"_pokemonsSummary"(也就是筛选后的清单)带入，
  // filter会return "pokemons"，也就是筛选结果。要是_pokemonsSummary是空值，即"不筛选"，
  // 则返回全部的怪兽，即原始Pokemons画面。至于_pokemonsSummary是啥数据，下面action有定义。

  @computed
  int get index {
    return pokemonsSummary!.indexWhere((it) => it.number == _pokemon!.number);
  }
  // 这就是说，有个 method 叫做 index，他会通过计算、依据特定要求，返回一个整数 int。
  // 要求是啥? 是 pokemonsSummary 里面有很多 pokemonSummary，这些 pokemonSummary 都有各自的 number。
  // 当某个 pokemonSummary 的 number 等于 _pokemon!.number (即当下的、用户点选的)，则返回数值。
  // 那么 _pokemon!.number 为啥是所谓"用户点选的"怪兽? 好像下面 action 会说。

  @computed
  List<PokemonSummary> get favoritesPokemonsSummary {
    return _favoritesPokemonsSummary;
  }

  @computed
  Pokemon? get pokemon {
    return _pokemon;
  }

  //========================================================================
  // action 要说明以下几个变数是啥、怎么获取:
  // 1. _pokemon 是哪个怪兽? 通过使用者点击来决定吗?
  // 2. filter(_pokemonsSummary) 里面的 _pokemonsSummary 是啥? 怎么从我的最爱获取?

  @action
  Future<void> setPokemon(int index) async {
    _pokemonSummary = pokemonsSummary![index];
    // 这句，意思是 每个小_pokemonSummary 等于 诸多pokemonsSummary中，个别index所对应的怪兽简介。
    // 那么，这诸多pokemonsSummary怎么来的? 前面有 List<PokemonSummary>? get pokemonsSummary {
    // return _pokemonFilter.filter(_pokemonsSummary); 他的 method 叫做 pokemonsSummary，
    // 方法所得的结果也叫做 pokemonsSummary。而这个结果是 filter(_pokemonsSummary) 得来的。
    // 意即，若 filter有东西筛选，则 pokemonsSummary![index] = _pokemonSummary = 筛选出来的几个怪兽。
    // 若 filter没有东西筛选，则 pokemonsSummary![index] = _pokemonSummary = 全部怪兽。

    final pokemonDetailsIndex =
        _pokemons.indexWhere((it) => it.number == _pokemonSummary!.number);
    // 每个小_pokemonSummary都有一个index，这里就是定义一个新变数，之后应用在 detail 页面。

    if (pokemonDetailsIndex < 0) {
      final fetchedPokemon =
          await _pokemonRepository.fetchPokemon(_pokemonSummary!.number);
      // 当 pokemonDetailsIndex = -1，意味着任何一个 _pokemons.indexWhere 皆不等于用户指定(onTap)的怪兽。
      // 这个 _pokemonRepository.fetchPokemon 得到的是从API并decode后，用户指定的某一个怪兽。

      final sortedPokemonList = [..._pokemons, fetchedPokemon];
      sortedPokemonList.sort((a, b) => a.number.compareTo(b.number));
      // 上面这是按照number大小排序。每个怪兽都有 String number这个property。

      _pokemons = sortedPokemonList;
      _pokemon = fetchedPokemon;
    } else {
      _pokemon = _pokemons[pokemonDetailsIndex];
      // 1. _pokemon 是哪个怪兽? 通过使用者点击来决定吗?
      // 由此得知，如果 pokemonDetailsIndex 大于等于0，例如[8]，则 _pokemon = 第8只怪兽。
    }
  }

  @action
  void addFavoritePokemon(String number) {
    final indexFavorite =
        _favoritesPokemonsSummary.indexWhere((it) => it.number == number);

    final indexAll = _pokemonsSummary!.indexWhere((it) => it.number == number);

    if (indexFavorite < 0 && indexAll >= 0) {
      _favoritesPokemonsSummary = ObservableList.of(
          [..._favoritesPokemonsSummary, _pokemonsSummary![indexAll]]);
    }

    _favoritesPokemonsSummary.sort((a, b) => a.number.compareTo(b.number));

    _pokemonRepository.saveFavoritePokemonSummary(
        _favoritesPokemonsSummary.map((it) => it.number).toList());
  }

  @action
  void removeFavoritePokemon(String number) {
    final index =
        _favoritesPokemonsSummary.indexWhere((it) => it.number == number);

    if (index >= 0) {
      _favoritesPokemonsSummary.removeAt(index);
      _favoritesPokemonsSummary =
          ObservableList.of([..._favoritesPokemonsSummary]);
    }

    _pokemonRepository.saveFavoritePokemonSummary(
        _favoritesPokemonsSummary.map((it) => it.number).toList());
  }

  @action
  void addGenerationFilter(Generation generationFilter) {
    _pokemonFilter =
        _pokemonFilter.copyWith(generationFilter: generationFilter);
  }

  @action
  void clearGenerationFilter() {
    _pokemonFilter = PokemonFilter(
        pokemonNameNumberFilter: _pokemonFilter.pokemonNameNumberFilter,
        typeFilter: _pokemonFilter.typeFilter);
  }

  @action
  void addTypeFilter(String type) {
    _pokemonFilter = _pokemonFilter.copyWith(typeFilter: type);
  }

  @action
  void clearTypeFilter() {
    _pokemonFilter = PokemonFilter(
        pokemonNameNumberFilter: _pokemonFilter.pokemonNameNumberFilter,
        generationFilter: _pokemonFilter.generationFilter);
  }

  @action
  void setNameNumberFilter(String nameNumberFilter) {
    _pokemonFilter =
        _pokemonFilter.copyWith(pokemonNameNumberFilter: nameNumberFilter);
  }

  @action
  void clearNameNumberFilter() {
    _pokemonFilter = PokemonFilter(
        generationFilter: _pokemonFilter.generationFilter,
        typeFilter: _pokemonFilter.typeFilter);
  }

  @action
  Future<void> fetchPokemonData() async {
    _pokemonsSummary = await _pokemonRepository.fetchPokemonsSummary();

    await _fetchFavoritesPokemons();
  }

  Future<void> previousPokemon() async {
    final pokemonIndex =
        pokemonsSummary!.indexWhere((it) => it.number == _pokemon!.number);

    await setPokemon(pokemonIndex - 1);
  }

  Future<void> nextPokemon() async {
    final pokemonIndex =
        pokemonsSummary!.indexWhere((it) => it.number == _pokemon!.number);

    await setPokemon(pokemonIndex + 1);
  }

  PokemonSummary getPokemon(int index) {
    return pokemonsSummary![index];
  }

  bool isFavorite(String number) {
    final index =
        _favoritesPokemonsSummary.indexWhere((it) => it.number == number);

    return index >= 0;
  }

  Future<void> _fetchFavoritesPokemons() async {
    final favorites = await _pokemonRepository.fetchFavoritesPokemonsSummary();

    _favoritesPokemonsSummary = ObservableList.of(_pokemonsSummary!
        .where((it) => favorites.contains(it.number))
        .toList());
  }
}
