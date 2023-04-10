import 'dart:io';
import 'dart:math';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/modules/pokemon_details/pokemon_details_store.dart';
import 'package:pokedex/modules/pokemon_details/widgets/app_bar_navigation.dart';
import 'package:pokedex/modules/pokemon_details/widgets/pokemon_pager.dart';
import 'package:pokedex/modules/pokemon_details/widgets/pokemon_panel/pokemon_mobile_panel.dart';
import 'package:pokedex/modules/pokemon_details/widgets/pokemon_title_info.dart';
import 'package:pokedex/shared/stores/pokemon_store/pokemon_store.dart';
import 'package:pokedex/shared/ui/canvas/background_dots.dart';
import 'package:pokedex/shared/ui/canvas/white_pokeball_canvas.dart';
import 'package:pokedex/shared/ui/enums/device_screen_type.dart';
import 'package:pokedex/shared/utils/converters.dart';
import 'package:pokedex/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme/dark/dark_theme.dart';
import '../../theme/light/light_theme.dart';

class PokemonDetailsPage extends StatefulWidget {
  final bool isFavoritePokemon;

  const PokemonDetailsPage({Key? key, this.isFavoritePokemon = false})
      : super(key: key);

  @override
  _PokemonDetailsPageState createState() => _PokemonDetailsPageState();
}

class _PokemonDetailsPageState extends State<PokemonDetailsPage>
    with SingleTickerProviderStateMixin {
  late PokemonStore _pokemonStore;
  late PokemonDetailsStore _pokemonDetailsStore;
  late AnimationController _animationController;
  late PageController _pageController;
  late AudioPlayer player;

  @override
  void initState() {
    super.initState();
    _pokemonStore = GetIt.instance<PokemonStore>();
    _pokemonDetailsStore = PokemonDetailsStore();
    _pageController =
        PageController(initialPage: _pokemonStore.index, viewportFraction: 0.4);

    player = AudioPlayer();

    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..repeat();
  }

  @override
  void dispose() {
    player.dispose();
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (getDeviceScreenType(context) == DeviceScreenType.CELLPHONE) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    return ThemeSwitchingArea(
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70),
            child: Stack(
              children: [
                // 第1个stack，是上面的appBar，即左箭头、爱心、昼夜模式的部份的底色而已。
                // 删掉的话，其实左箭头、爱心、昼夜模式都还在。
                Observer(
                  builder: (_) {
                    return Container(
                      height: size.height,
                      width: size.width,
                      color: AppTheme.colors
                          .pokemonItem(_pokemonStore.pokemon!.types[0]),
                    );
                  },
                ),
                // 第2个stack，不知道???。
                Positioned(
                  top: -83 + padding.top,
                  left: -70,
                  child: Transform.rotate(
                    angle: getRadiansFromDegree(75),
                    child: Opacity(
                      opacity: 0.1,
                      child: Container(
                        height: 144,
                        width: 144,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 80,
                  top: padding.top,
                  child: Opacity(
                    opacity: 0.2,
                    child: CustomPaint(
                      size: Size(57, (57 * 0.543859649122807).toDouble()),
                      painter: BackgroundDotsPainter(),
                    ),
                  ),
                ),
                Observer(builder: (_) {
                  return AppBar(
                    title: AnimatedOpacity(
                        duration: Duration(milliseconds: 30),
                        opacity: _pokemonDetailsStore.opacityTitleAppbar,
                        child: Visibility(
                          child: AppBarNavigationWidget(),
                          visible: _pokemonDetailsStore.opacityTitleAppbar > 0,
                        )),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back,
                          color: AppTheme.getColors(context)
                              .pokemonDetailsTitleColor),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    actions: [
                      if (_pokemonStore
                          .isFavorite(_pokemonStore.pokemon!.number))
                        IconButton(
                          icon: Icon(
                            Icons.favorite,
                            color: AppTheme.getColors(context)
                                .pokemonDetailsTitleColor,
                          ),
                          onPressed: () {
                            _pokemonStore.removeFavoritePokemon(
                                _pokemonStore.pokemon!.number);

                            BotToast.showText(
                                text:
                                    "${_pokemonStore.pokemon!.name} was removed from favorites");
                          },
                        ),
                      if (!_pokemonStore
                          .isFavorite(_pokemonStore.pokemon!.number))
                        IconButton(
                          icon: Icon(Icons.favorite_border,
                              color: AppTheme.getColors(context)
                                  .pokemonDetailsTitleColor),
                          onPressed: () {
                            _pokemonStore.addFavoritePokemon(
                                _pokemonStore.pokemon!.number);
                            BotToast.showText(
                                text:
                                    "${_pokemonStore.pokemon!.name} was favorited");
                          },
                        ),
                      IconButton(
                        onPressed: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                        icon: ThemeSwitcher(builder: (context) {
                          return InkWell(
                            onTap: () async {
                              ThemeSwitcher.of(context)?.changeTheme(
                                  theme: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? darkTheme
                                      : lightTheme);

                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setBool(
                                  "darkTheme",
                                  !(Theme.of(context).brightness ==
                                      Brightness.dark));
                            },
                            child: Icon(
                                Theme.of(context).brightness == Brightness.light
                                    ? Icons.dark_mode
                                    : Icons.light_mode,
                                color: AppTheme.getColors(context)
                                    .pokemonDetailsTitleColor),
                          );
                        }),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Flexible(
                    flex: 1,
                    child: Row(
                      children: [
                        Container(
                          width: size.width,
                          height: size.height,
                          child: Stack(
                            children: [
                              //下面的observer，是中间部份，怪兽大图、旋转球的部份"的底色"。
                              Observer(builder: (_) {
                                return Container(
                                  color: AppTheme.colors.pokemonItem(
                                      _pokemonStore.pokemon!.types[0]),
                                );
                              }),
                              // 下面的Align，只是子页面上面的圆角的造型。
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30),
                                    ),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                  ),
                                  height: 80,
                                ),
                              ),
                              // 下面这observer，是中间那颗一直转的球的图、颜色、位置等。
                              Observer(
                                builder: (_) => Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: AnimatedOpacity(
                                      duration: Duration(milliseconds: 30),
                                      opacity:
                                          _pokemonDetailsStore.opacityPokemon,
                                      child: SizedBox(
                                        height: 223,
                                        child: Center(
                                          child: AnimatedBuilder(
                                            animation: _animationController,
                                            builder: (_, child) {
                                              return Transform.rotate(
                                                angle:
                                                    _animationController.value *
                                                        2 *
                                                        pi,
                                                child: child,
                                              );
                                            },
                                            child: CustomPaint(
                                              size: Size(
                                                  200,
                                                  (200 * 1.0040160642570282)
                                                      .toDouble()),
                                              painter: PokeballLogoPainter(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .background
                                                      .withOpacity(0.3)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // 下面这observer，是中间大怪物、与左右两侧上一个、下一个怪兽的东西。
                              Observer(
                                builder: (_) => Align(
                                  alignment: Alignment.bottomCenter,
                                  child: AnimatedOpacity(
                                    duration: Duration(milliseconds: 300),
                                    opacity:
                                        _pokemonDetailsStore.opacityPokemon,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 30),
                                      child: Container(
                                        height: 220,
                                        child: Stack(
                                          children: [
                                            PokemonPagerWidget(
                                              pageController: _pageController,
                                              pokemonDetailStore:
                                                  _pokemonDetailsStore,
                                              isFavorite:
                                                  widget.isFavoritePokemon,
                                            ),
                                            if ((kIsWeb &&
                                                    getDeviceScreenType(
                                                            context) !=
                                                        DeviceScreenType
                                                            .CELLPHONE) ||
                                                (!kIsWeb &&
                                                    (Platform.isWindows ||
                                                        Platform.isLinux ||
                                                        Platform.isMacOS)))
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 60),
                                                    child: InkWell(
                                                      child: Icon(
                                                        Icons.arrow_back_ios,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .background
                                                            .withOpacity(0.3),
                                                        size: 70,
                                                      ),
                                                      onTap: () {
                                                        _pageController.previousPage(
                                                            duration: Duration(
                                                                milliseconds:
                                                                    300),
                                                            curve: Curves
                                                                .fastLinearToSlowEaseIn);
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 280,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 70),
                                                    child: InkWell(
                                                      child: Icon(
                                                        Icons.arrow_forward_ios,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .background
                                                            .withOpacity(0.3),
                                                        size: 60,
                                                      ),
                                                      onTap: () {
                                                        _pageController.nextPage(
                                                            duration: Duration(
                                                                milliseconds:
                                                                    300),
                                                            curve: Curves
                                                                .fastLinearToSlowEaseIn);
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // 下面这个，是怪兽页面上，上面怪兽名称、属性、编号的部份。
                              Observer(
                                builder: (_) => AnimatedOpacity(
                                  duration: Duration(milliseconds: 30),
                                  opacity: _pokemonDetailsStore.opacityPokemon,
                                  child: PokemonTitleInfoWidget(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 下面是以页面的上面圆角，还不能0、2、10，就得1。
                  Flexible(
                    flex: 1,
                    child: Row(
                      children: [
                        Container(
                          width: size.width,
                          height: size.height,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              // 第2个stack，是四个(about/base stats...)的页面。
              Container(
                width: size.width,
                height: size.height,
                // 下面的PokemonMobilePanelWidget，是具体四个怪兽详细资料的子页面。
                child: PokemonMobilePanelWidget(
                  listener: (position) {
                    _pokemonDetailsStore.setProgress(position, 0.0, 0.65);

                    return true;
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
