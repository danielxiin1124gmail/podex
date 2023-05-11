import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
//import 'package:pokedex/modules/pokemon_details/widgets/pokemon_panel/pages/base_stats/utils/table_row_factory.dart';

//import 'package:pokedex/modules/pokemon_details/widgets/pokemon_panel/pages/base_stats/widgets/base_stats_item.dart';
import 'package:pokedex/modules/tennisPlayer_details/widgets/tennisPlayer_panel/pages/base_stats/widgets/base_stats_item.dart';

import 'package:pokedex/shared/stores/pokemon_store/pokemon_store.dart';
import 'package:pokedex/shared/stores/tennisPlayer_store/tennisPlayer_store.dart';

//import '../../pokemon_mobile_panel.dart';
import '../../tennisPlayer_mobile_panel.dart';

class BaseStatsPage extends StatelessWidget {
  static final _tennisPlayerStore = GetIt.instance<TennisPlayerStore>();

  const BaseStatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    final size = MediaQuery.of(context).size;

    final horizontalPadding = getDetailsPanelsPadding(size);

    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              const BaseStatsItemWidget(
                title: "FH",
              ),
              const BaseStatsItemWidget(
                title: "BH",
              ),
              const BaseStatsItemWidget(
                title: "SRV",
              ),
              const BaseStatsItemWidget(
                title: "VOL",
              ),
              const BaseStatsItemWidget(
                title: "POW",
              ),
              const BaseStatsItemWidget(
                title: "STA",
              ),
              const BaseStatsItemWidget(
                title: "SPE",
                //maxValue: 1200,
                // 本来maxValue 预设是200，在此设定成1200。
              ),
            ],
          ),
          SizedBox(height: 40),
          /*Text(
            "Type Effectiveness",
            style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),*/
          SizedBox(height: 20),
          /*Observer(
            builder: (_) => Table(
              columnWidths: {0: const FixedColumnWidth(100)},
              // 0代表第一个column，然后固定成 100 pixel。其他column动态显示，不做定义。
              children: [
                TableRowFactory.build(context,
                    title: "Damaged normally by",
                    types: _pokemonStore.pokemon!.typesEffectiveness.entries
                        .where((it) => it.value == "1")),
                // 他的API里面，typesEffectiveness有很多分为1、2、0.5的属性，全部放在typesEffectiveness里面。
                // 若要从中分类筛选，得加上".entries"，然后配合"where"，来指定要筛选啥。
                TableRowFactory.build(context,
                    title: "Weak to",
                    types: _pokemonStore.pokemon!.typesEffectiveness.entries
                        .where((it) => it.value == "2")),
                TableRowFactory.build(context,
                    title: "Resistant to",
                    types: _pokemonStore.pokemon!.typesEffectiveness.entries
                        .where((it) => it.value == "½" || it.value == "¼")),
                TableRowFactory.build(context,
                    title: "Immune to",
                    types: _pokemonStore.pokemon!.typesEffectiveness.entries
                        .where((it) => it.value == "0")),
              ],
            ),
          ),*/
          SizedBox(
            height: 300,
          )
        ],
      ),
    );
  }
}
