import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import 'package:pokedex/modules/pokemon_details/pokemon_details_store.dart';
import 'package:pokedex/modules/tennisPlayer_details/tennisPlayer_details_store.dart';

import 'package:pokedex/shared/stores/pokemon_store/pokemon_store.dart';
import 'package:pokedex/shared/stores/tennisPlayer_store/tennisPlayer_store.dart';

import 'package:pokedex/shared/utils/image_utils.dart';

class TennisPlayerPagerWidget extends StatefulWidget {
  final PageController pageController;
  final TennisPlayerDetailsStore tennisPlayerDetailStore;
  final bool isFavorite;

  TennisPlayerPagerWidget(
      {Key? key,
      required this.pageController,
      required this.tennisPlayerDetailStore,
      this.isFavorite = false})
      : super(key: key);

  @override
  _TennisPlayerPagerState createState() =>
      _TennisPlayerPagerState(this.pageController);
}

class _TennisPlayerPagerState extends State<TennisPlayerPagerWidget> {
  final PageController pageController;
  late TennisPlayerStore _tennisPlayerStore =
      GetIt.instance<TennisPlayerStore>();
  late ReactionDisposer _updatePagerReaction;

  _TennisPlayerPagerState(this.pageController);

  @override
  void initState() {
    super.initState();

    _tennisPlayerStore = GetIt.instance<TennisPlayerStore>();

    _updatePagerReaction = autorun((_) async => {
          if (widget.tennisPlayerDetailStore.opacityTitleAppbar == 1 &&
              _tennisPlayerStore.index != pageController)
            {
              await pageController.animateToPage(_tennisPlayerStore.index,
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
        itemCount: _tennisPlayerStore.tennisPlayersSummary!.length,
        onPageChanged: _tennisPlayerStore.setTennisPlayer,
        allowImplicitScrolling: true,
        itemBuilder: (context, index) {
          final listTennisPlayer =
              _tennisPlayerStore.tennisPlayersSummary![index];

          return Observer(
            builder: (_) {
              return AnimatedPadding(
                padding: EdgeInsets.all(
                    _tennisPlayerStore.tennisPlayerSummary!.number ==
                            listTennisPlayer.number
                        ? 0
                        : 40),
                duration: Duration(milliseconds: 300),
                child: Container(
                  child: _tennisPlayerStore.tennisPlayerSummary!.number ==
                          listTennisPlayer.number
                      ? Hero(
                          tag: widget.isFavorite
                              ? "favorite-tennisPlayer-image-${listTennisPlayer.number}"
                              : "tennisPlayer-image-${listTennisPlayer.number}",
                          child: ImageUtils.networkImage(
                            url: listTennisPlayer.imageUrl,
                            height: 300,
                            color: _tennisPlayerStore
                                        .tennisPlayerSummary!.number ==
                                    listTennisPlayer.number
                                ? null
                                : Colors.black.withOpacity(0.2),
                          ),
                        )
                      : ImageUtils.networkImage(
                          url: listTennisPlayer.imageUrl,
                          height: 300,
                          color:
                              _tennisPlayerStore.tennisPlayerSummary!.number ==
                                      listTennisPlayer.number
                                  ? null
                                  : Colors.black.withOpacity(0.2),
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
