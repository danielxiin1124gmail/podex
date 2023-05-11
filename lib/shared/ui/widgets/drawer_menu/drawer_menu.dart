import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';
import 'package:pokedex/modules/home/home_page_store.dart';
import 'package:pokedex/shared/ui/widgets/animated_pokeball.dart';
import 'package:pokedex/shared/ui/widgets/drawer_menu/widgets/drawer_menu_item.dart';
import 'package:pokedex/shared/utils/app_constants.dart';
import 'package:pokedex/theme/app_theme.dart';

class DrawerMenuWidget extends StatefulWidget {
  const DrawerMenuWidget({Key? key}) : super(key: key);

  @override
  State<DrawerMenuWidget> createState() => _DrawerMenuWidgetState();
}

class _DrawerMenuWidgetState extends State<DrawerMenuWidget>
    with TickerProviderStateMixin {
  final HomePageStore _homeStore = GetIt.instance<HomePageStore>();

  late AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..repeat();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  // 下面是那个红色GameBoy的图标
                  Image.asset(
                    AppConstants.pokedexIcon,
                    width: 100,
                    height: 100,
                  ),
                  // 下面是旋转宝贝球+Pokedex图样。
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedPokeballWidget(
                          color: AppTheme.getColors(context).pokeballLogoBlack,
                          size: 24),
                      SizedBox(
                        width: 5,
                      ),
                      Text("Pokedex", style: textTheme.displayLarge),
                    ],
                  ),
                ],
              ),
              GridView(
                shrinkWrap: true,
                // 改成false会error，貌似可能还得补上啥数字。这行是说grid是否依据内文自动调整长宽之类的。
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 70,
                ),
                // 这里是六个菜单的设定页面。其实DrawerMenuItemWidget就像是自定义的button。
                children: [
                  DrawerMenuItemWidget(
                    color: AppTheme.getColors(context).drawerPokedex,
                    text: "Pokedex",
                    onTap: () {
                      Navigator.pop(context);
                      // 这个pop，主要是点击菜单之后，不但跳到该跳转的页面，同时关闭drawer。

                      _homeStore.setPage(HomePageType.POKEMON_GRID);
                    },
                  ),
                  DrawerMenuItemWidget(
                    color: AppTheme.getColors(context).drawerItems,
                    text: "Items",
                    onTap: () {
                      Navigator.pop(context);

                      _homeStore.setPage(HomePageType.ITENS);
                    },
                  ),
                  DrawerMenuItemWidget(
                    color: AppTheme.getColors(context).drawerTennisPlayers,
                    text: "Tennis Players",
                    onTap: () {
                      Navigator.pop(context);

                      _homeStore.setPage(HomePageType.TENNIS_PLAYER_GRID);
                    },
                  ),
                  DrawerMenuItemWidget(
                    color: AppTheme.getColors(context).drawerTennisItems,
                    text: "Tennis Items",
                    onTap: () {
                      Navigator.pop(context);

                      _homeStore.setPage(HomePageType.TENNIS_ITEMS);
                    },
                  ),
                  DrawerMenuItemWidget(
                      color: AppTheme.getColors(context).drawerMoves,
                      text: "Moves"),
                  DrawerMenuItemWidget(
                      color: AppTheme.getColors(context).drawerAbilities,
                      text: "Abilities"),
                  DrawerMenuItemWidget(
                      color: AppTheme.getColors(context).drawerTypeCharts,
                      text: "Type Charts"),
                  DrawerMenuItemWidget(
                      color: AppTheme.getColors(context).drawerLocations,
                      text: "Locations"),
                ],
              ),
            ],
          ),
          // 下面Align，主要是右下角土黄色蚯蚓的动画。
          Align(
            alignment: Alignment.bottomRight,
            child: Lottie.asset(
              AppConstants.diglettLottie,
              height: 200.0,
            ),
          ),
        ],
      ),
    );
  }
}
