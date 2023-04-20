import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:pokedex/modules/home/home_page_store.dart';
import 'package:pokedex/modules/home/widgets/home_panel/panels/pokemon_favorites.dart';
import 'package:pokedex/modules/home/widgets/home_panel/panels/pokemon_generation_filter.dart';
import 'package:pokedex/modules/home/widgets/home_panel/panels/pokemon_type_filter.dart';
import 'package:pokedex/modules/home/widgets/home_panel/panels/text_filter.dart';
import 'package:pokedex/shared/stores/item_store/item_store.dart';
import 'package:pokedex/shared/stores/pokemon_store/pokemon_store.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomePanelWidget extends StatelessWidget {
  final PanelController panelController;
  final HomePageStore homePageStore;
  final PokemonStore pokemonStore;
  final ItemStore itemStore;

  const HomePanelWidget(
      {Key? key,
      required this.panelController,
      required this.homePageStore,
      required this.pokemonStore,
      required this.itemStore})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      late double maxHeight;

      if (homePageStore.panelType != null &&
          homePageStore.panelType!.isTextFilter) {
        maxHeight = 100;
        // 上面是FAB文字搜索浮窗高度，设定为100。
      } else {
        maxHeight = MediaQuery.of(context).size.height * 0.75;
        // 上面是FAB除了文字搜索以外，其他浮窗(例如几代怪兽、我的最爱等)，设定为四分之三个画面高度。
      }

      return SlidingUpPanel(
          maxHeight: maxHeight,
          minHeight: MediaQuery.of(context).size.height * 0.0,
          parallaxEnabled: true,
          parallaxOffset: 0.5,
          // 上面这两个parallax我实在没感觉出差异，无论数值怎么变化。
          // 用途是，让子画面上划速度与内容上划速度有差异。
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: Theme.of(context).colorScheme.background,
          boxShadow: [
            // 这个BoxShadow只是子画面的上缘的阴影，其实看不清楚。
            // 这个BoxShadow是list，可以放多个颜色，例如再贴上Colors.red，就会看到两色阴影。
            BoxShadow(
              color: Color(0xFF000000).withOpacity(0.9),
              blurRadius: 10.0,
            ),
          ],
          onPanelClosed: () {
            homePageStore.closeFilter(); // 去掉这两个会导致关闭panel后，看不到FAB。
          },
          onPanelOpened: () {
            homePageStore.openFilter(); // 去掉这两个会导致关闭panel后，看不到FAB。
          },
          controller: panelController,
          panelBuilder: (scrollController) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  // 这padding只影响panel上方的横杠，不影响下方filter的怪兽的卡片padding。
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 这个只是 panel上方的横杠，给他底色、宽与高，做的像是一条线。
                      Container(
                        color: Color(0xFFd4d4d4),
                        height: 4,
                        width: 80,
                      )
                    ],
                  ),
                ),
                // 下面这些是实际 panel 所显示的 filter的引用方式。
                if (homePageStore.panelType == PanelType.FILTER_POKEMON_TYPE)
                  PokemonTypeFilter(
                    homePageStore: homePageStore,
                    scrollController: scrollController,
                  ),
                if (homePageStore.panelType ==
                    PanelType.FILTER_POKEMON_GENERATION)
                  PokemonGenerationFilter(
                    homePageStore: homePageStore,
                    scrollController: scrollController,
                  ),
                if (homePageStore.panelType ==
                    PanelType.FILTER_POKEMON_NAME_NUMBER)
                  TextFilterWidget(
                    // 这里是 filter 里面的文字搜索子画面。
                    hintText: "Ex: Charizard or 006", // 搜索栏位初始 hint。
                    text: pokemonStore.pokemonFilter.pokemonNameNumberFilter,
                    // 这行意义是把我们所输入的搜寻文字，定义到pokemonNameNumberFilter。
                    // 当前发现移除此行一切正常；区别在于，当完全收起文字搜索浮窗后，FAB会跑出来，
                    // 如果又再次点击文字搜索，在去掉本行的情况下，输入框内会显示预设hint；
                    // 若保留，假设我搜索005，则输入框内会显示预设005。
                    homePageStore: homePageStore,
                    onChanged: (value) {
                      pokemonStore.setNameNumberFilter(value);
                    },
                    onClose: () {
                      panelController.close();
                      pokemonStore.clearNameNumberFilter();
                      // clearNameNumberFilter 很重要，一旦关闭文字搜索，才能显示回全部怪兽。
                    },
                  ),
                if (homePageStore.panelType == PanelType.FILTER_ITEMS)
                  TextFilterWidget(
                    hintText: "Ex: Ultraball",
                    text: itemStore.filter,
                    // filter 是在 item_store.g.dart里面。
                    // 上面两个TextFilterWidget中的这行逻辑不太一样。当前不明白。
                    homePageStore: homePageStore,
                    onChanged: (value) {
                      itemStore.setFilter(value);
                    },
                    onClose: () {
                      panelController.close();
                      itemStore.clearFilter();
                      // clearFilter 很重要，一旦关闭文字搜索，才能显示回全部物品。
                    },
                  ),
                if (homePageStore.panelType == PanelType.FAVORITES_POKEMONS)
                  PokemonFavorites(
                    homePageStore: homePageStore,
                    scrollController: scrollController,
                  ),
              ],
            );
          });
    });
  }
}
