// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tennisPlayer_details_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TennisPlayerDetailsStore on _TennisPlayerDetailsStoreBase, Store {
  Computed<double>? _$progressComputed;

  @override
  double get progress =>
      (_$progressComputed ??= Computed<double>(() => super.progress,
              name: '_TennisPlayerDetailsStoreBase.progress'))
          .value;
  Computed<double>? _$opacityTitleAppbarComputed;

  @override
  double get opacityTitleAppbar => (_$opacityTitleAppbarComputed ??=
          Computed<double>(() => super.opacityTitleAppbar,
              name: '_TennisPlayerDetailsStoreBase.opacityTitleAppbar'))
      .value;
  Computed<double>? _$opacityTennisPlayerComputed;

  @override
  double get opacityTennisPlayer => (_$opacityTennisPlayerComputed ??=
          Computed<double>(() => super.opacityTennisPlayer,
              name: '_TennisPlayerDetailsStoreBase.opacityTennisPlayer'))
      .value;

  late final _$_progressAtom =
      Atom(name: '_TennisPlayerDetailsStoreBase._progress', context: context);

  @override
  double get _progress {
    _$_progressAtom.reportRead();
    return super._progress;
  }

  @override
  set _progress(double value) {
    _$_progressAtom.reportWrite(value, super._progress, () {
      super._progress = value;
    });
  }

  late final _$_opacityTitleAppbarAtom = Atom(
      name: '_TennisPlayerDetailsStoreBase._opacityTitleAppbar',
      context: context);

  @override
  double get _opacityTitleAppbar {
    _$_opacityTitleAppbarAtom.reportRead();
    return super._opacityTitleAppbar;
  }

  @override
  set _opacityTitleAppbar(double value) {
    _$_opacityTitleAppbarAtom.reportWrite(value, super._opacityTitleAppbar, () {
      super._opacityTitleAppbar = value;
    });
  }

  late final _$_opacityTennisPlayerAtom = Atom(
      name: '_TennisPlayerDetailsStoreBase._opacityTennisPlayer',
      context: context);

  @override
  double get _opacityTennisPlayer {
    _$_opacityTennisPlayerAtom.reportRead();
    return super._opacityTennisPlayer;
  }

  @override
  set _opacityTennisPlayer(double value) {
    _$_opacityTennisPlayerAtom.reportWrite(value, super._opacityTennisPlayer,
        () {
      super._opacityTennisPlayer = value;
    });
  }

  late final _$_TennisPlayerDetailsStoreBaseActionController =
      ActionController(name: '_TennisPlayerDetailsStoreBase', context: context);

  @override
  void setProgress(double progress, double lower, double upper) {
    final _$actionInfo = _$_TennisPlayerDetailsStoreBaseActionController
        .startAction(name: '_TennisPlayerDetailsStoreBase.setProgress');
    try {
      return super.setProgress(progress, lower, upper);
    } finally {
      _$_TennisPlayerDetailsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
progress: ${progress},
opacityTitleAppbar: ${opacityTitleAppbar},
opacityTennisPlayer: ${opacityTennisPlayer}
    ''';
  }
}
