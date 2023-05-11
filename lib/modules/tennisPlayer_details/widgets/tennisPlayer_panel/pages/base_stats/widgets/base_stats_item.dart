import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/shared/stores/pokemon_store/pokemon_store.dart';
import 'package:pokedex/shared/stores/tennisPlayer_store/tennisPlayer_store.dart';
import 'package:pokedex/theme/app_theme.dart';

class BaseStatsItemWidget extends StatelessWidget {
  final String title;
  final int maxValue;

  static final _tennisPlayerStore = GetIt.instance<TennisPlayerStore>();

  const BaseStatsItemWidget(
      {Key? key, required this.title, this.maxValue = 200})
      : super(key: key);

  double get barPercentage => value() / maxValue;

  int value() {
    // 也许统一用大写，比较不会错?
    switch (title.toUpperCase()) {
      case "FH":
        return _tennisPlayerStore.tennisPlayer!.baseStats.fh;
      case "BH":
        return _tennisPlayerStore.tennisPlayer!.baseStats.bh;
      case "SRV":
        return _tennisPlayerStore.tennisPlayer!.baseStats.srv;
      case "VOL":
        return _tennisPlayerStore.tennisPlayer!.baseStats.vol;
      case "POW":
        return _tennisPlayerStore.tennisPlayer!.baseStats.pow;
      case "STA":
        return _tennisPlayerStore.tennisPlayer!.baseStats.sta;
      case "SPE":
        return _tennisPlayerStore.tennisPlayer!.baseStats.spe;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 第一个，是HP / Attack等标题。
          Container(
            width: 87,
            child: Opacity(
              opacity: 0.4,
              child: Text(title, style: textTheme.bodyLarge),
            ),
          ),
          // 第二个，是数值。
          Observer(
            builder: (_) => Container(
              width: 40,
              child: Text(
                value().toString(),
                style: textTheme.bodyLarge,
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Stack(
              children: [
                // 第一个子项，是数值条的底色，白色。
                Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: Color(0xFFF4F5F4),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  //color: Colors.red,
                ),
                // 第二个子项，是实际数值的横条图，但我没看出来有啥3秒动画。
                Observer(
                  builder: (_) => FractionallySizedBox(
                    widthFactor: barPercentage,
                    child: AnimatedContainer(
                      duration: Duration(seconds: 3),
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppTheme.getColors(context)
                            .baseStatsBar(barPercentage),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
