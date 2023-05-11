import 'package:mobx/mobx.dart';
part 'tennisPlayer_details_store.g.dart';

class TennisPlayerDetailsStore = _TennisPlayerDetailsStoreBase
    with _$TennisPlayerDetailsStore;

abstract class _TennisPlayerDetailsStoreBase with Store {
  // 下面是下方上滑子页面缓缓淡出的参数一之。因为要被拿来做计算，所以要observe，观察实时数值。
  @observable
  double _progress = 0;

  // 下面是下方上滑子页面缓缓淡出的参数一之。因为要被拿来做计算，所以要observe，观察实时数值。
  @observable
  double _opacityTitleAppbar = 0;

  // 下面是下方上滑子页面缓缓淡出的参数一之。因为要被拿来做计算，所以要observe，观察实时数值。
  @observable
  double _opacityTennisPlayer = 1;

  // 下面是下方上滑子页面缓缓淡出的参数一之。就竟实时数值是多少? 就 get progress => _progress，
  // 然后 mobx就会神奇的、反正能get数值。
  @computed
  double get progress => _progress;

  @computed
  double get opacityTitleAppbar => _opacityTitleAppbar;

  @computed
  double get opacityTennisPlayer => _opacityTennisPlayer;

  // 下面的setProgress，意义是使下方上滑子页面一但上滑，上面的怪兽名称、图标缓缓淡出。
  @action
  void setProgress(double progress, double lower, double upper) {
    _progress = progress;
    _opacityTitleAppbar = _calcOpacityTitleAppbar(lower, upper);
    _opacityTennisPlayer = _setOpacityTennisPlayer(lower, upper);
  }

  double _calcOpacityTitleAppbar(double lower, double upper) {
    assert(lower < upper);

    return ((_progress - lower) / (upper - lower)).clamp(0.0, 1.0);
  }

  double _setOpacityTennisPlayer(double lower, double upper) {
    assert(lower < upper);

    return 1 - ((_progress - lower) / (upper - lower)).clamp(0.0, 1.0);
  }
}
