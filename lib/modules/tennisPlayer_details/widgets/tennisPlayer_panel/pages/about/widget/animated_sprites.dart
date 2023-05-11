/*
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/shared/stores/pokemon_store/pokemon_store.dart';
import 'package:pokedex/shared/utils/image_utils.dart';
import 'package:pokedex/theme/app_theme.dart';

class AnimatedSpritesWidget extends StatelessWidget {
  static final _pokemonStore = GetIt.instance<PokemonStore>();

  final bool isShiny;

  const AnimatedSpritesWidget({
    Key? key,
    required this.isShiny,
  }) : super(key: key);

  String get frontTitle =>
      isShiny ? "Front animated \n shiny sprite" : "Front animated \n sprite";

  String get backTitle =>
      isShiny ? "Back animated \n shiny sprite" : "Back animated \n sprite";

  // shiny与否，有不同 API Url。
  String get frontUrl => isShiny
      ? _pokemonStore.pokemon!.sprites.frontShinyAnimatedSpriteUrl!
      : _pokemonStore.pokemon!.sprites.frontAnimatedSpriteUrl!;

  String get backUrl => isShiny
      ? _pokemonStore.pokemon!.sprites.backShinyAnimatedSpriteUrl!
      : _pokemonStore.pokemon!.sprites.backAnimatedSpriteUrl!;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // row有两个column，第一个是左边的 front view。
          Column(
            children: [
              // observer，就是怪兽的动图。
              Observer(
                builder: (_) => ImageUtils.networkImage(
                  height: 65,
                  width: 65,
                  url: frontUrl,
                ),
              ),
              // front动图的文字叙述。
              Text(
                frontTitle,
                style: textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          // row有两个column，第2个是左边的 rear view。
          Column(
            children: [
              Observer(
                builder: (_) => ImageUtils.networkImage(
                  height: 65,
                  width: 65,
                  url: backUrl,
                ),
              ),
              Text(
                backTitle,
                style: textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
*/
