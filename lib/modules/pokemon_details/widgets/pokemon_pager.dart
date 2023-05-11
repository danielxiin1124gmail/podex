import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:pokedex/modules/pokemon_details/pokemon_details_store.dart';
import 'package:pokedex/shared/stores/pokemon_store/pokemon_store.dart';
import 'package:pokedex/shared/utils/image_utils.dart';

class PokemonPagerWidget extends StatefulWidget {
  final PageController pageController;
  final PokemonDetailsStore pokemonDetailStore;
  final bool isFavorite;

  PokemonPagerWidget(
      {Key? key,
      required this.pageController,
      required this.pokemonDetailStore,
      this.isFavorite = false})
      : super(key: key);

  @override
  _PokemonPagerState createState() => _PokemonPagerState(this.pageController);
}

class _PokemonPagerState extends State<PokemonPagerWidget> {
  final PageController pageController;
  late PokemonStore _pokemonStore = GetIt.instance<PokemonStore>();
  late ReactionDisposer _updatePagerReaction;

  _PokemonPagerState(this.pageController);

  @override
  void initState() {
    super.initState();

    _pokemonStore = GetIt.instance<PokemonStore>();

    _updatePagerReaction = autorun((_) async => {
          if (widget.pokemonDetailStore.opacityTitleAppbar == 1 &&
              _pokemonStore.index != pageController)
            {
              await pageController.animateToPage(_pokemonStore.index,
                  duration: Duration(microseconds: 300),
                  curve: Curves.bounceIn),
            }
        });
  }

  @override
  void dispose() {
    _updatePagerReaction();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 223 * MediaQuery.of(context).devicePixelRatio,
      child: PageView.builder(
        controller: pageController,
        itemCount: _pokemonStore.pokemonsSummary!.length,
        onPageChanged: _pokemonStore.setPokemon,
        allowImplicitScrolling: true,
        itemBuilder: (context, index) {
          final listPokemon = _pokemonStore.pokemonsSummary![index];

          return Observer(
            builder: (_) {
              return AnimatedPadding(
                // 下面的padding，是控制上一个、下一个怪兽阴影比较小，当前怪兽比较大的地方。
                padding: EdgeInsets.all(
                    _pokemonStore.pokemonSummary!.number == listPokemon.number
                        ? 0
                        : 40),
                duration: Duration(milliseconds: 300),
                child: Container(
                  //color: Colors.red,
                  child: _pokemonStore.pokemonSummary!.number ==
                          listPokemon.number
                      // 左中右三只怪兽，若是当前怪兽，则以Hero方式显示图片。若Hero改成Container()，
                      // 会发现中间的当前怪兽空了。
                      // 我目前无法理解为啥我只能看到 n-1, n, n+1 三只怪兽，为啥无法 n-2, n-1, n, n+1, and n+2 五只。
                      ? Hero(
                          tag: widget.isFavorite
                              ? "favorite-pokemon-image-${listPokemon.number}"
                              : "pokemon-image-${listPokemon.number}",
                          child: ImageUtils.networkImage(
                            url: listPokemon.imageUrl,
                            height: 300,
                            color: _pokemonStore.pokemonSummary!.number ==
                                    listPokemon.number
                                ? null
                                : Colors.black.withOpacity(0.2),
                          ),
                        )
                      : ImageUtils.networkImage(
                          url: listPokemon.imageUrl,
                          height: 300,
                          color: _pokemonStore.pokemonSummary!.number ==
                                  listPokemon.number
                              ? null
                              : Colors.black.withOpacity(0.2),
                          // 前一个、下一个，若是改成:null，则前一个、下一个变彩色。
                          // 前一个、下一个，若是改成:withOpacity(1)，则前一个、下一个变全黑。
                          // 若去掉: ImageUtils.，则前一个、下一个会消失。
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
