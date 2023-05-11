import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import 'package:pokedex/shared/stores/pokemon_store/pokemon_store.dart';
import 'package:pokedex/shared/stores/tennisPlayer_store/tennisPlayer_store.dart';

import 'package:pokedex/theme/app_theme.dart';

class TennisPlayerTitleInfoWidget extends StatelessWidget {
  final _tennisPlayerStore = GetIt.instance<TennisPlayerStore>();

  TennisPlayerTitleInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Observer(builder: (_) {
                return Text(
                  _tennisPlayerStore.tennisPlayer!.name,
                  style: textTheme.displayLarge?.copyWith(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.getColors(context)
                        .tennisPlayerDetailsTitleColor,
                  ),
                );
              }),
              Observer(builder: (_) {
                return Text("#${_tennisPlayerStore.tennisPlayer!.number}",
                    style: textTheme.headlineMedium?.copyWith(
                      color: AppTheme.getColors(context)
                          .tennisPlayerDetailsTitleColor,
                    ));
              }),
            ],
          ),
          SizedBox(
            height: 6,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 这边的 observer，是怪兽名称下方一两个种类"Grass" 或 "Poison" 等的map。
              Observer(builder: (_) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: _tennisPlayerStore.tennisPlayer!.types
                      .map((type) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                child: Text(type,
                                    style: textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.getColors(context)
                                          .tennisPlayerDetailsTitleColor,
                                    )),
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(38),
                                  color: AppTheme.getColors(context)
                                      .tennisPlayerDetailsTitleColor
                                      .withOpacity(0.4)),
                            ),
                          ))
                      .toList(),
                );
              }),
              // 这边的 observer，指的是怪兽编号下方的 "Lizard Pokemon"字样。
              /*Observer(
                builder: (_) {
                  return Text("${_pokemonStore.pokemon!.specie} Pokemon",
                      style: textTheme.bodyLarge?.copyWith(
                        color: AppTheme.getColors(context)
                            .pokemonDetailsTitleColor,
                      ));
                },
              ),*/
            ],
          )
        ],
      ),
    );
  }
}
