import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';
import 'package:pokedex/modules/home/home_page_store.dart';

import 'package:pokedex/modules/pokemon_details/pokemon_details.dart';
import 'package:pokedex/modules/tennisPlayer_details/tennisPlayer_details.dart';

//import 'package:pokedex/modules/pokemon_details/widgets/pokemon_panel/pokemon_mobile_panel.dart';
import 'package:pokedex/modules/tennisPlayer_details/widgets/tennisPlayer_panel/tennisPlayer_mobile_panel.dart';

import 'package:pokedex/modules/pokemon_grid/widgets/poke_item.dart';
import 'package:pokedex/modules/tennisPlayer_grid/widgets/tennisPlayer_item.dart';

import 'package:pokedex/shared/stores/pokemon_store/pokemon_store.dart';
import 'package:pokedex/shared/stores/tennisPlayer_store/tennisPlayer_store.dart';

import 'package:pokedex/shared/utils/app_constants.dart';

class TennisPlayerFavorites extends StatelessWidget {
  static final TennisPlayerStore tennisPlayerStore =
      GetIt.instance<TennisPlayerStore>();
  final ScrollController scrollController;
  final HomePageStore homePageStore;

  const TennisPlayerFavorites(
      {Key? key, required this.homePageStore, required this.scrollController})
      : super(key: key);

  double get topPadding {
    // 这里暂时没研究，一方面只是padding，二来当前Edge读取不出怪兽清单。
    if (tennisPlayerStore.favoritesTennisPlayersSummary.isNotEmpty) {
      return kIsWeb ? 68 : 50; // 是web，则68；是手机，则50。
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    final size = MediaQuery.of(context).size;

    final horizontalPadding = getDetailsPanelsPadding(size);
    // 这是 Favorite里面怪兽卡片的左右两侧 padding。

    if (tennisPlayerStore.favoritesTennisPlayersSummary.isEmpty) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "You do not have any favorite tennis player yet",
              style: textTheme.bodyLarge,
            ),
            Center(
              child: Lottie.asset(
                AppConstants.pikachuLottie,
                width: 400,
              ),
            )
          ],
        ),
      );
    }
    // 为何不 if+else? 若这样改，Widget build 会红底线，说null问题。Build之后的return，
    // 不能仅仅建立在if之上。

    return Padding(
      padding: EdgeInsets.only(
          left: horizontalPadding, right: horizontalPadding, top: 28),
      // top: 28 是指 "Favorite Pokemons" 与上方横杠的间距。
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: topPadding),
            child: NestedScrollView(
              headerSliverBuilder: (context, value) {
                return [];
                // NestedScrollView 意义在于，如果说这个浮窗还有其他可滑动的菜单，例如在上方的左右滑动的小菜单，
                // 则能有此功能。但刚好这个 app 没有，所以他其实是空的。
              },
              body: GridView.builder(
                // Nick日历教学里面是用 GridView.count。ChatGPT说 .count比较简单，因为可调整的参数少。
                // GridView.builder is more flexible because it allows you to create a grid
                // of any size, with any number of rows and columns, and it can handle an infinite number of items。
                controller: scrollController,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  // 这决定了怪兽卡片的大小。改成300，会剩一列；改成50，会四五列但是很小。
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 3 / 2,
                ),
                itemBuilder: (context, index) {
                  final _tennisPlayer =
                      tennisPlayerStore.favoritesTennisPlayersSummary[index];
                  final _index = tennisPlayerStore.tennisPlayersSummary!
                      .indexWhere((it) => it.number == _tennisPlayer.number);
                  // 既然_pokemon指的是已加入最爱的怪兽，那_pokemon.number 就是其编号。
                  // 因为 pokemon_store.dart 里面有定义 PokemonSummary 具备 "number"这property。
                  // 如果 it.number(全清单的编号) = _pokemon.number(最爱清单的编号)，则 index它。

                  return InkWell(
                    onTap: () async {
                      await tennisPlayerStore.setTennisPlayer(_index);

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) {
                          return TennisPlayerDetailsPage(
                            isFavoriteTennisPlayer: false,
                            // 当前没明白这里 false / true 意义在哪。
                          );
                        }),
                      );
                    },
                    // 下面的child，是最爱怪兽里面的卡片设计。包含背景的球、#001位置等。
                    // 估计 PokeItemWidget 就是GridView内的卡片设计，应该在全部宝贝页面也会引用。
                    child: Ink(
                      child: TennisPlayerItemWidget(
                        tennisPlayer: _tennisPlayer,
                        isFavorite: true,
                      ),
                    ),
                  );
                },
                itemCount:
                    tennisPlayerStore.favoritesTennisPlayersSummary.length,
              ),
            ),
          ),
          Container(
            // 这边 Container 只是上方 "Favorites Pokemons" 字样而已。
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Favorites Tennis Players",
                  style: textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
