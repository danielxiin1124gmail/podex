// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tennisItem_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TennisItemStore on _tennisItemStoreBase, Store {
  Computed<String?>? _$filterComputed;

  @override
  String? get filter =>
      (_$filterComputed ??= Computed<String?>(() => super.filter,
              name: '_tennisItemStoreBase.filter'))
          .value;
  Computed<List<TennisItem>>? _$tennisItemsComputed;

  @override
  List<TennisItem> get tennisItems => (_$tennisItemsComputed ??=
          Computed<List<TennisItem>>(() => super.tennisItems,
              name: '_tennisItemStoreBase.tennisItems'))
      .value;

  late final _$_tennisItemsAtom =
      Atom(name: '_tennisItemStoreBase._tennisItems', context: context);

  @override
  List<TennisItem> get _tennisItems {
    _$_tennisItemsAtom.reportRead();
    return super._tennisItems;
  }

  @override
  set _tennisItems(List<TennisItem> value) {
    _$_tennisItemsAtom.reportWrite(value, super._tennisItems, () {
      super._tennisItems = value;
    });
  }

  late final _$_filterAtom =
      Atom(name: '_tennisItemStoreBase._filter', context: context);

  @override
  String? get _filter {
    _$_filterAtom.reportRead();
    return super._filter;
  }

  @override
  set _filter(String? value) {
    _$_filterAtom.reportWrite(value, super._filter, () {
      super._filter = value;
    });
  }

  late final _$fetchTennisItemsAsyncAction =
      AsyncAction('_tennisItemStoreBase.fetchTennisItems', context: context);

  @override
  Future<void> fetchTennisItems() {
    return _$fetchTennisItemsAsyncAction.run(() => super.fetchTennisItems());
  }

  late final _$_tennisItemStoreBaseActionController =
      ActionController(name: '_tennisItemStoreBase', context: context);

  @override
  void setFilter(String filter) {
    final _$actionInfo = _$_tennisItemStoreBaseActionController.startAction(
        name: '_tennisItemStoreBase.setFilter');
    try {
      return super.setFilter(filter);
    } finally {
      _$_tennisItemStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearFilter() {
    final _$actionInfo = _$_tennisItemStoreBaseActionController.startAction(
        name: '_tennisItemStoreBase.clearFilter');
    try {
      return super.clearFilter();
    } finally {
      _$_tennisItemStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
filter: ${filter},
tennisItems: ${tennisItems}
    ''';
  }
}
