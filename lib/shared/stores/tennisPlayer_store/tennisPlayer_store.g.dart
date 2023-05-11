// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tennisPlayer_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TennisPlayerStore on _TennisPlayerStoreBase, Store {
  Computed<TennisPlayerFilter>? _$tennisPlayerFilterComputed;

  @override
  TennisPlayerFilter get tennisPlayerFilter => (_$tennisPlayerFilterComputed ??=
          Computed<TennisPlayerFilter>(() => super.tennisPlayerFilter,
              name: '_TennisPlayerStoreBase.tennisPlayerFilter'))
      .value;
  Computed<TennisPlayerSummary?>? _$tennisPlayerSummaryComputed;

  @override
  TennisPlayerSummary? get tennisPlayerSummary =>
      (_$tennisPlayerSummaryComputed ??= Computed<TennisPlayerSummary?>(
              () => super.tennisPlayerSummary,
              name: '_TennisPlayerStoreBase.tennisPlayerSummary'))
          .value;
  Computed<List<TennisPlayerSummary>?>? _$tennisPlayersSummaryComputed;

  @override
  List<TennisPlayerSummary>? get tennisPlayersSummary =>
      (_$tennisPlayersSummaryComputed ??= Computed<List<TennisPlayerSummary>?>(
              () => super.tennisPlayersSummary,
              name: '_TennisPlayerStoreBase.tennisPlayersSummary'))
          .value;
  Computed<int>? _$indexComputed;

  @override
  int get index => (_$indexComputed ??= Computed<int>(() => super.index,
          name: '_TennisPlayerStoreBase.index'))
      .value;
  Computed<int>? _$apiAddressComputed;

  @override
  int get apiAddress =>
      (_$apiAddressComputed ??= Computed<int>(() => super.apiAddress,
              name: '_TennisPlayerStoreBase.apiAddress'))
          .value;
  Computed<List<TennisPlayerSummary>>? _$favoritesTennisPlayersSummaryComputed;

  @override
  List<TennisPlayerSummary> get favoritesTennisPlayersSummary =>
      (_$favoritesTennisPlayersSummaryComputed ??=
              Computed<List<TennisPlayerSummary>>(
                  () => super.favoritesTennisPlayersSummary,
                  name: '_TennisPlayerStoreBase.favoritesTennisPlayersSummary'))
          .value;
  Computed<TennisPlayer?>? _$tennisPlayerComputed;

  @override
  TennisPlayer? get tennisPlayer => (_$tennisPlayerComputed ??=
          Computed<TennisPlayer?>(() => super.tennisPlayer,
              name: '_TennisPlayerStoreBase.tennisPlayer'))
      .value;

  late final _$_tennisPlayerFilterAtom = Atom(
      name: '_TennisPlayerStoreBase._tennisPlayerFilter', context: context);

  @override
  TennisPlayerFilter get _tennisPlayerFilter {
    _$_tennisPlayerFilterAtom.reportRead();
    return super._tennisPlayerFilter;
  }

  @override
  set _tennisPlayerFilter(TennisPlayerFilter value) {
    _$_tennisPlayerFilterAtom.reportWrite(value, super._tennisPlayerFilter, () {
      super._tennisPlayerFilter = value;
    });
  }

  late final _$_tennisPlayerSummaryAtom = Atom(
      name: '_TennisPlayerStoreBase._tennisPlayerSummary', context: context);

  @override
  TennisPlayerSummary? get _tennisPlayerSummary {
    _$_tennisPlayerSummaryAtom.reportRead();
    return super._tennisPlayerSummary;
  }

  @override
  set _tennisPlayerSummary(TennisPlayerSummary? value) {
    _$_tennisPlayerSummaryAtom.reportWrite(value, super._tennisPlayerSummary,
        () {
      super._tennisPlayerSummary = value;
    });
  }

  late final _$_tennisPlayersSummaryAtom = Atom(
      name: '_TennisPlayerStoreBase._tennisPlayersSummary', context: context);

  @override
  List<TennisPlayerSummary>? get _tennisPlayersSummary {
    _$_tennisPlayersSummaryAtom.reportRead();
    return super._tennisPlayersSummary;
  }

  @override
  set _tennisPlayersSummary(List<TennisPlayerSummary>? value) {
    _$_tennisPlayersSummaryAtom.reportWrite(value, super._tennisPlayersSummary,
        () {
      super._tennisPlayersSummary = value;
    });
  }

  late final _$_favoritesTennisPlayersSummaryAtom = Atom(
      name: '_TennisPlayerStoreBase._favoritesTennisPlayersSummary',
      context: context);

  @override
  ObservableList<TennisPlayerSummary> get _favoritesTennisPlayersSummary {
    _$_favoritesTennisPlayersSummaryAtom.reportRead();
    return super._favoritesTennisPlayersSummary;
  }

  @override
  set _favoritesTennisPlayersSummary(
      ObservableList<TennisPlayerSummary> value) {
    _$_favoritesTennisPlayersSummaryAtom
        .reportWrite(value, super._favoritesTennisPlayersSummary, () {
      super._favoritesTennisPlayersSummary = value;
    });
  }

  late final _$_tennisPlayersAtom =
      Atom(name: '_TennisPlayerStoreBase._tennisPlayers', context: context);

  @override
  List<TennisPlayer> get _tennisPlayers {
    _$_tennisPlayersAtom.reportRead();
    return super._tennisPlayers;
  }

  @override
  set _tennisPlayers(List<TennisPlayer> value) {
    _$_tennisPlayersAtom.reportWrite(value, super._tennisPlayers, () {
      super._tennisPlayers = value;
    });
  }

  late final _$_tennisPlayerAtom =
      Atom(name: '_TennisPlayerStoreBase._tennisPlayer', context: context);

  @override
  TennisPlayer? get _tennisPlayer {
    _$_tennisPlayerAtom.reportRead();
    return super._tennisPlayer;
  }

  @override
  set _tennisPlayer(TennisPlayer? value) {
    _$_tennisPlayerAtom.reportWrite(value, super._tennisPlayer, () {
      super._tennisPlayer = value;
    });
  }

  late final _$setTennisPlayerAsyncAction =
      AsyncAction('_TennisPlayerStoreBase.setTennisPlayer', context: context);

  @override
  Future<void> setTennisPlayer(int index) {
    return _$setTennisPlayerAsyncAction.run(() => super.setTennisPlayer(index));
  }

  late final _$fetchTennisPlayerDataAsyncAction = AsyncAction(
      '_TennisPlayerStoreBase.fetchTennisPlayerData',
      context: context);

  @override
  Future<void> fetchTennisPlayerData() {
    return _$fetchTennisPlayerDataAsyncAction
        .run(() => super.fetchTennisPlayerData());
  }

  late final _$_TennisPlayerStoreBaseActionController =
      ActionController(name: '_TennisPlayerStoreBase', context: context);

  @override
  void addFavoriteTennisPlayer(String number) {
    final _$actionInfo = _$_TennisPlayerStoreBaseActionController.startAction(
        name: '_TennisPlayerStoreBase.addFavoriteTennisPlayer');
    try {
      return super.addFavoriteTennisPlayer(number);
    } finally {
      _$_TennisPlayerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeFavoriteTennisPlayer(String number) {
    final _$actionInfo = _$_TennisPlayerStoreBaseActionController.startAction(
        name: '_TennisPlayerStoreBase.removeFavoriteTennisPlayer');
    try {
      return super.removeFavoriteTennisPlayer(number);
    } finally {
      _$_TennisPlayerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addTypeFilter(String type) {
    final _$actionInfo = _$_TennisPlayerStoreBaseActionController.startAction(
        name: '_TennisPlayerStoreBase.addTypeFilter');
    try {
      return super.addTypeFilter(type);
    } finally {
      _$_TennisPlayerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearTypeFilter() {
    final _$actionInfo = _$_TennisPlayerStoreBaseActionController.startAction(
        name: '_TennisPlayerStoreBase.clearTypeFilter');
    try {
      return super.clearTypeFilter();
    } finally {
      _$_TennisPlayerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setNameNumberFilter(String nameNumberFilter) {
    final _$actionInfo = _$_TennisPlayerStoreBaseActionController.startAction(
        name: '_TennisPlayerStoreBase.setNameNumberFilter');
    try {
      return super.setNameNumberFilter(nameNumberFilter);
    } finally {
      _$_TennisPlayerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearNameNumberFilter() {
    final _$actionInfo = _$_TennisPlayerStoreBaseActionController.startAction(
        name: '_TennisPlayerStoreBase.clearNameNumberFilter');
    try {
      return super.clearNameNumberFilter();
    } finally {
      _$_TennisPlayerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addStyleFilter(String style) {
    final _$actionInfo = _$_TennisPlayerStoreBaseActionController.startAction(
        name: '_TennisPlayerStoreBase.addStyleFilter');
    try {
      return super.addStyleFilter(style);
    } finally {
      _$_TennisPlayerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearStyleFilter() {
    final _$actionInfo = _$_TennisPlayerStoreBaseActionController.startAction(
        name: '_TennisPlayerStoreBase.clearStyleFilter');
    try {
      return super.clearStyleFilter();
    } finally {
      _$_TennisPlayerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addCountryFilter(String country) {
    final _$actionInfo = _$_TennisPlayerStoreBaseActionController.startAction(
        name: '_TennisPlayerStoreBase.addCountryFilter');
    try {
      return super.addCountryFilter(country);
    } finally {
      _$_TennisPlayerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearCountryFilter() {
    final _$actionInfo = _$_TennisPlayerStoreBaseActionController.startAction(
        name: '_TennisPlayerStoreBase.clearCountryFilter');
    try {
      return super.clearCountryFilter();
    } finally {
      _$_TennisPlayerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addRightOrLeftFilter(String rightOrLeft) {
    final _$actionInfo = _$_TennisPlayerStoreBaseActionController.startAction(
        name: '_TennisPlayerStoreBase.addRightOrLeftFilter');
    try {
      return super.addRightOrLeftFilter(rightOrLeft);
    } finally {
      _$_TennisPlayerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearRightOrLeftFilter() {
    final _$actionInfo = _$_TennisPlayerStoreBaseActionController.startAction(
        name: '_TennisPlayerStoreBase.clearRightOrLeftFilter');
    try {
      return super.clearRightOrLeftFilter();
    } finally {
      _$_TennisPlayerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addBackhandStyleFilter(String backhandStyle) {
    final _$actionInfo = _$_TennisPlayerStoreBaseActionController.startAction(
        name: '_TennisPlayerStoreBase.addBackhandStyleFilter');
    try {
      return super.addBackhandStyleFilter(backhandStyle);
    } finally {
      _$_TennisPlayerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearBackhandStyleFilter() {
    final _$actionInfo = _$_TennisPlayerStoreBaseActionController.startAction(
        name: '_TennisPlayerStoreBase.clearBackhandStyleFilter');
    try {
      return super.clearBackhandStyleFilter();
    } finally {
      _$_TennisPlayerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
tennisPlayerFilter: ${tennisPlayerFilter},
tennisPlayerSummary: ${tennisPlayerSummary},
tennisPlayersSummary: ${tennisPlayersSummary},
index: ${index},
apiAddress: ${apiAddress},
favoritesTennisPlayersSummary: ${favoritesTennisPlayersSummary},
tennisPlayer: ${tennisPlayer}
    ''';
  }
}
