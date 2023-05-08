import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:pokedex/shared/models/pokemon.dart';
import 'package:pokedex/shared/models/tennisPlayer.dart';

import 'package:pokedex/shared/models/pokemon_filter.dart';
import 'package:pokedex/shared/models/tennisPlayer_filter.dart';

import 'package:pokedex/shared/models/pokemon_summary.dart';
import 'package:pokedex/shared/models/tennisPlayer_summary.dart';

import 'package:pokedex/shared/repositories/pokemon_repository.dart';
import 'package:pokedex/shared/repositories/tennisPlayer_repository.dart';

part 'tennisPlayer_store.g.dart';

class TennisPlayerStore = _TennisPlayerStoreBase with _$TennisPlayerStore;
// (B)_PokemonStoreBase 在下面定义了。
// (C)_$PokemonStore 这是 "flutter packages pub run build_runner build" 生成的。
// PokemonStore = B + C。

abstract class _TennisPlayerStoreBase with Store {
  TennisPlayerRepository _tennisPlayerRepository =
      GetIt.instance<TennisPlayerRepository>();
  // 他这一步是在 fetching Pokemon data。

  @observable
  TennisPlayerFilter _tennisPlayerFilter = TennisPlayerFilter();
  // 这里是说，_pokemonFilter = PokemonFilter() 这个 class尔以；
  // 还不是 PokemonFilter() 里面的三个 filter 判断式的搜寻、筛选结果。还不是。

  @observable
  TennisPlayerSummary? _tennisPlayerSummary;
  // 我觉得有问号的原因，是因为_tennisPlayerSummary真的可以是null。万一乱搜索，自然有可能搜不到怪兽。

  @observable
  List<TennisPlayerSummary>? _tennisPlayersSummary;
  // 每个小 pokemonsSummary 的list。

  @observable
  ObservableList<TennisPlayerSummary> _favoritesTennisPlayersSummary =
      ObservableList();
  //----------------------------------------------------------------------
  @observable
  List<TennisPlayer> _tennisPlayers = [];

  @observable
  TennisPlayer? _tennisPlayer;
  //----------------------------------------------------------------------
  @computed
  TennisPlayerFilter get tennisPlayerFilter => _tennisPlayerFilter;

  @computed
  TennisPlayerSummary? get tennisPlayerSummary => _tennisPlayerSummary;
  // 中间没有s，pokemonSummary。

  @computed
  List<TennisPlayerSummary>? get tennisPlayersSummary =>
      _tennisPlayerFilter.filter(_tennisPlayersSummary);

  // 中间有s，pokemonsSummary。
  // 这里其实就是首页"Pokemons"的数据。filter以"_pokemonsSummary"(也就是筛选后的清单)带入，
  // filter会return "pokemons"，也就是筛选结果。要是_pokemonsSummary是空值，即"不筛选"，
  // 则返回全部的怪兽，即原始Pokemons画面。至于_pokemonsSummary是啥数据，下面action有定义。

  @computed
  int get index {
    return tennisPlayersSummary!
        .indexWhere((it) => it.number == _tennisPlayer!.number);
  }

  // 这就是说，有个 method 叫做 index，他会通过计算、依据特定要求，返回一个整数 int。
  // 要求是啥? 是 pokemon"s"Summary 里面有很多 pokemonSummary，这些 pokemonSummary 都有各自的 number。
  // 当某个 pokemonSummary 的 number 等于 _pokemon!.number (即当下的、用户点选的)，则返回数值。
  // 那么 _pokemon!.number 为啥是所谓"用户点选的"怪兽? 好像下面 action 会说。
  @computed
  int get apiAddress {
    return tennisPlayersSummary!
        .indexWhere((it) => it.apiAddress == _tennisPlayer!.apiAddress);
  }
  // 这是依样话胡芦。apiAddress 是 String ，之所以开头是 int，是因为这里只是要把用户指定的球员信息中，
  // 包含的 apiAddress (或number) 把他个序列号(indexWhere)。
  // 所以我感觉，我这抄的有点多余。他这并不是要拿 number 去 fetch tennisPlayer，只是编个号尔以。
  // 拿 number编号、与拿 apiAddress编号，都是编号，应该无所谓。

  @computed
  List<TennisPlayerSummary> get favoritesTennisPlayersSummary {
    return _favoritesTennisPlayersSummary;
  }

  @computed
  TennisPlayer? get tennisPlayer {
    return _tennisPlayer;
  }

  //========================================================================
  // action 要说明以下几个变数是啥、怎么获取:
  // 1. _pokemon 是哪个怪兽? 通过使用者点击来决定吗?
  // 2. filter(_pokemonsSummary) 里面的 _pokemonsSummary 是啥? 怎么从我的最爱获取?

  // 下面action，还没 100%理解；ChatGPT 搜索关键字 logic，有整段解说。
  @action
  Future<void> setTennisPlayer(int index) async {
    _tennisPlayerSummary = tennisPlayersSummary![index];
    // 这句，意思是 每个小_pokemonSummary 等于 诸多pokemonsSummary中，个别index所对应的怪兽简介。
    // 那么，这诸多pokemonsSummary怎么来的? 前面有 List<PokemonSummary>? get pokemonsSummary {
    // return _pokemonFilter.filter(_pokemonsSummary); 他的 method 叫做 pokemonsSummary，
    // 方法所得的结果也叫做 pokemonsSummary。而这个结果是 filter(_pokemonsSummary) 得来的。
    // 意即，若 filter有东西筛选，则 pokemonsSummary![index] = _pokemonSummary = 筛选出来的几个怪兽。
    // 若 filter没有东西筛选，则 pokemonsSummary![index] = _pokemonSummary = 全部怪兽。

    final tennisPlayerDetailsIndex = _tennisPlayers
        .indexWhere((it) => it.number == _tennisPlayerSummary!.number);
    // 每个小_pokemonSummary都有一个index，这里就是定义一个新变数，之后应用在 detail 页面。
    // 下面有 sort，sort肯定得按照 number来排序，因此这里不太可能需要改成 apiAddress。

    if (tennisPlayerDetailsIndex < 0) {
      final fetchedTennisPlayer = await _tennisPlayerRepository
          .fetchTennisPlayer(_tennisPlayerSummary!.apiAddress);
      // 当 pokemonDetailsIndex = -1，意味着任何一个 _pokemons.indexWhere 皆不等于用户指定(onTap)的怪兽。
      // 注意，这里我改成.apiAddress了。毕竟，他不是拿number去组合出API的网址，而是拿apiAddress去组合出API的网址。
      // 作者有自己网站，他能设定API地址是 001.json、002.json、003.json等，我不能，JSON Generator网站没这功能。

      final sortedTennisPlayerList = [..._tennisPlayers, fetchedTennisPlayer];
      sortedTennisPlayerList.sort((a, b) => a.number.compareTo(b.number));
      // 上面这是按照number大小排序。每个怪兽都有 String number这个property。

      _tennisPlayers = sortedTennisPlayerList;
      _tennisPlayer = fetchedTennisPlayer;
    } else {
      _tennisPlayer = _tennisPlayers[tennisPlayerDetailsIndex];
      // 1. _pokemon 是哪个怪兽? 通过使用者点击来决定吗?
      // 由此得知，如果 pokemonDetailsIndex 大于等于0，例如[8]，则 _pokemon = 第8只怪兽。
    }
  }

  @action
  void addFavoriteTennisPlayer(String number) {
    final indexFavorite =
        _favoritesTennisPlayersSummary.indexWhere((it) => it.number == number);

    final indexAll =
        _tennisPlayersSummary!.indexWhere((it) => it.number == number);

    if (indexFavorite < 0 && indexAll >= 0) {
      // 我感觉，indexFavorite < 0，意义是确认点击新增最爱的瞬间，判断当前的球员编号(例如001 Federer)，
      // 是否不在 _favoritesTennisPlayersSummary 中(是否=-1)；若不在，则用[...]来新增到其中。
      _favoritesTennisPlayersSummary = ObservableList.of([
        ..._favoritesTennisPlayersSummary,
        _tennisPlayersSummary![indexAll]
      ]);
    }

    _favoritesTennisPlayersSummary.sort((a, b) => a.number.compareTo(b.number));

    _tennisPlayerRepository.saveFavoriteTennisPlayerSummary(
        _favoritesTennisPlayersSummary.map((it) => it.number).toList());
  }

  @action
  void removeFavoriteTennisPlayer(String number) {
    final index =
        _favoritesTennisPlayersSummary.indexWhere((it) => it.number == number);

    if (index >= 0) {
      _favoritesTennisPlayersSummary.removeAt(index);
      _favoritesTennisPlayersSummary =
          ObservableList.of([..._favoritesTennisPlayersSummary]);
    }

    _tennisPlayerRepository.saveFavoriteTennisPlayerSummary(
        _favoritesTennisPlayersSummary.map((it) => it.number).toList());
  }

  /*@action
  void addGenerationFilter(Generation generationFilter) {
    _pokemonFilter =
        _pokemonFilter.copyWith(generationFilter: generationFilter);
  }

  @action
  void clearGenerationFilter() {
    _pokemonFilter = PokemonFilter(
        pokemonNameNumberFilter: _pokemonFilter.pokemonNameNumberFilter,
        typeFilter: _pokemonFilter.typeFilter);
  }*/

  @action
  void addTypeFilter(String type) {
    _tennisPlayerFilter = _tennisPlayerFilter.copyWith(typeFilter: type);
  }

  @action
  void clearTypeFilter() {
    _tennisPlayerFilter = TennisPlayerFilter(
      tennisPlayerNameNumberFilter:
          _tennisPlayerFilter.tennisPlayerNameNumberFilter,
      typeFilter: null,
      styleFilter: _tennisPlayerFilter.styleFilter,
      countryFilter: _tennisPlayerFilter.countryFilter,
      rightOrLeftFilter: _tennisPlayerFilter.rightOrLeftFilter,
      backhandStyleFilter: _tennisPlayerFilter.backhandStyleFilter,
      // 这里之所以也写上NameNumber/generationFilter等，是因为此处是"取消TypeFilter"，
      // 取消之后，剩下的要依然保留筛选状态；剩下的，即为当下其他筛选条件。
    );
  }

  @action
  void setNameNumberFilter(String nameNumberFilter) {
    _tennisPlayerFilter = _tennisPlayerFilter.copyWith(
        tennisPlayerNameNumberFilter: nameNumberFilter);
  }

  @action
  void clearNameNumberFilter() {
    _tennisPlayerFilter = TennisPlayerFilter(
      tennisPlayerNameNumberFilter: null,
      typeFilter: _tennisPlayerFilter.typeFilter,
      styleFilter: _tennisPlayerFilter.styleFilter,
      countryFilter: _tennisPlayerFilter.countryFilter,
      rightOrLeftFilter: _tennisPlayerFilter.rightOrLeftFilter,
      backhandStyleFilter: _tennisPlayerFilter.backhandStyleFilter,
    );
  }

  @action
  void addStyleFilter(String style) {
    _tennisPlayerFilter = _tennisPlayerFilter.copyWith(styleFilter: style);
  }

  @action
  void clearStyleFilter() {
    _tennisPlayerFilter = TennisPlayerFilter(
      tennisPlayerNameNumberFilter:
          _tennisPlayerFilter.tennisPlayerNameNumberFilter,
      typeFilter: _tennisPlayerFilter.typeFilter,
      styleFilter: null,
      countryFilter: _tennisPlayerFilter.countryFilter,
      rightOrLeftFilter: _tennisPlayerFilter.rightOrLeftFilter,
      backhandStyleFilter: _tennisPlayerFilter.backhandStyleFilter,
    );
  }

  @action
  void addCountryFilter(String country) {
    _tennisPlayerFilter = _tennisPlayerFilter.copyWith(countryFilter: country);
  }

  @action
  void clearCountryFilter() {
    _tennisPlayerFilter = TennisPlayerFilter(
      tennisPlayerNameNumberFilter:
          _tennisPlayerFilter.tennisPlayerNameNumberFilter,
      typeFilter: _tennisPlayerFilter.typeFilter,
      styleFilter: _tennisPlayerFilter.styleFilter,
      countryFilter: null,
      rightOrLeftFilter: _tennisPlayerFilter.rightOrLeftFilter,
      backhandStyleFilter: _tennisPlayerFilter.backhandStyleFilter,
    );
  }

  @action
  void addRightOrLeftFilter(String rightOrLeft) {
    _tennisPlayerFilter =
        _tennisPlayerFilter.copyWith(rightOrLeftFilter: rightOrLeft);
  }

  @action
  void clearRightOrLeftFilter() {
    _tennisPlayerFilter = TennisPlayerFilter(
      tennisPlayerNameNumberFilter:
          _tennisPlayerFilter.tennisPlayerNameNumberFilter,
      typeFilter: _tennisPlayerFilter.typeFilter,
      styleFilter: _tennisPlayerFilter.styleFilter,
      countryFilter: _tennisPlayerFilter.countryFilter,
      rightOrLeftFilter: null,
      backhandStyleFilter: _tennisPlayerFilter.backhandStyleFilter,
    );
  }

  @action
  void addBackhandStyleFilter(String backhandStyle) {
    _tennisPlayerFilter =
        _tennisPlayerFilter.copyWith(backhandStyleFilter: backhandStyle);
  }

  @action
  void clearBackhandStyleFilter() {
    _tennisPlayerFilter = TennisPlayerFilter(
      tennisPlayerNameNumberFilter:
          _tennisPlayerFilter.tennisPlayerNameNumberFilter,
      typeFilter: _tennisPlayerFilter.typeFilter,
      styleFilter: _tennisPlayerFilter.styleFilter,
      countryFilter: _tennisPlayerFilter.countryFilter,
      rightOrLeftFilter: _tennisPlayerFilter.rightOrLeftFilter,
      backhandStyleFilter: null,
    );
  }

  @action
  Future<void> fetchTennisPlayerData() async {
    _tennisPlayersSummary =
        await _tennisPlayerRepository.fetchTennisPlayersSummary();

    await _fetchFavoritesTennisPlayers();
  }

  Future<void> _fetchFavoritesTennisPlayers() async {
    final favorites =
        await _tennisPlayerRepository.fetchFavoritesTennisPlayersSummary();

    _favoritesTennisPlayersSummary = ObservableList.of(_tennisPlayersSummary!
        .where((it) => favorites.contains(it.number))
        .toList());
  }

  Future<void> previousTennisPlayer() async {
    final tennisPlayerIndex = tennisPlayersSummary!
        .indexWhere((it) => it.number == _tennisPlayer!.number);

    await setTennisPlayer(tennisPlayerIndex - 1);
  }

  Future<void> nextTennisPlayer() async {
    final tennisPlayerIndex = tennisPlayersSummary!
        .indexWhere((it) => it.number == _tennisPlayer!.number);

    await setTennisPlayer(tennisPlayerIndex + 1);
  }

  TennisPlayerSummary getTennisPlayer(int index) {
    return tennisPlayersSummary![index];
  }

  bool isFavorite(String number) {
    final index =
        _favoritesTennisPlayersSummary.indexWhere((it) => it.number == number);

    return index >= 0;
  }
}
