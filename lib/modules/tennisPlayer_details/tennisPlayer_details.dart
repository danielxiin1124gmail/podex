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
import 'package:pokedex/modules/tennisPlayer_details/tennisPlayer_details_store.dart';

import 'package:pokedex/modules/pokemon_details/widgets/pokemon_pager.dart';
import 'package:pokedex/modules/tennisPlayer_details/widgets/tennisPlayer_pager.dart';

import 'package:pokedex/modules/pokemon_details/widgets/pokemon_panel/pokemon_mobile_panel.dart';
import 'package:pokedex/modules/tennisPlayer_details/widgets/tennisPlayer_panel/tennisPlayer_mobile_panel.dart';

import 'package:pokedex/modules/pokemon_details/widgets/pokemon_title_info.dart';
import 'package:pokedex/modules/tennisPlayer_details/widgets/tennisPlayer_title_info.dart';

import 'package:pokedex/shared/stores/pokemon_store/pokemon_store.dart';
import 'package:pokedex/shared/stores/tennisPlayer_store/tennisPlayer_store.dart';

import 'package:pokedex/modules/pokemon_details/widgets/app_bar_navigation.dart';
import 'package:pokedex/modules/tennisPlayer_details/widgets/app_bar_navigation_tennisPlayer.dart';

import 'package:pokedex/shared/ui/canvas/background_dots.dart';
import 'package:pokedex/shared/ui/canvas/white_pokeball_canvas.dart';
import 'package:pokedex/shared/ui/enums/device_screen_type.dart';
import 'package:pokedex/shared/utils/converters.dart';
import 'package:pokedex/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme/dark/dark_theme.dart';
import '../../theme/light/light_theme.dart';

class TennisPlayerDetailsPage extends StatefulWidget {
  final bool isFavoriteTennisPlayer;

  const TennisPlayerDetailsPage({Key? key, this.isFavoriteTennisPlayer = false})
      : super(key: key);

  @override
  _TennisPlayerDetailsPageState createState() =>
      _TennisPlayerDetailsPageState();
}

class _TennisPlayerDetailsPageState extends State<TennisPlayerDetailsPage>
    with SingleTickerProviderStateMixin {
  // SingleTickerProviderStateMixin: 当有数个动画需要"一个"ticker时，用这个。
  // TickerProviderStateMixin: 当有数个动画需要"多个"ticker时，用这个。
  late TennisPlayerStore _tennisPlayerStore;
  late TennisPlayerDetailsStore _tennisPlayerDetailsStore;
  late AnimationController _animationController;
  late PageController _pageController;
  late AudioPlayer player;

  @override
  void initState() {
    super.initState();
    _tennisPlayerStore = GetIt.instance<TennisPlayerStore>();
    _tennisPlayerDetailsStore = TennisPlayerDetailsStore();
    _pageController = PageController(
        initialPage: _tennisPlayerStore.index, viewportFraction: 0.4);
    // viewportFraction: 0.4，影响了detail页面的怪兽大小。调成1，会看到怪兽变大，且后面的怪兽消失。
    // 调成0.1，会看到怪兽变的非常小，后面的怪兽能看到但也非常小。
    // 这边的_pageController，指的就是怪兽图示区域可以侧滑上、下一只怪兽的page。
    player = AudioPlayer();

    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..repeat();
    // _animationController就是怪兽后面那颗转动球的初始设定，需要被initialize。
  }

  @override
  void dispose() {
    // 我们无须在任何代码中，主动呼叫dispose()，因为flutter在该StatefulWidget 消失、关闭页面时，会自动呼叫。
    player.dispose();
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (getDeviceScreenType(context) == DeviceScreenType.CELLPHONE) {
      // 这边是让detail screen仅限portrait mode。怪兽、物品页面可以横屏，但详细资料面确实不行。
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    return ThemeSwitchingArea(
      // ThemeSwitchingArea，我猜是不同属性怪兽，色系会不同，他要自动变换。
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70),
            // 上面这preferredSize，类似于上方的safeArea，只是控制整体怪兽名字、编号、下方动画的高低位置。
            child: Stack(
              children: [
                // 第1个stack，是上面的appBar，即左箭头、爱心、昼夜模式的部份的底色而已。
                Observer(
                  // 删掉的话，其实左箭头、爱心、昼夜模式都还在。
                  builder: (_) {
                    return Container(
                      height: size.height,
                      width: size.width,
                      color: AppTheme.colors.tennisPlayerItem(
                          _tennisPlayerStore.tennisPlayer!.types[0]),
                    );
                  },
                ),
                // 第2个stack，就只是左上角、箭头后面的一个背景圆角灰色方块而以。
                Positioned(
                  // 他用BoxDecoration + borderRadius，创造出一个背景圆角灰色方块。
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
                // 第3个stack，就只是上方那5x3的白点点。他用CustomPainter画的。
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
                // 第4个stack，就下面的Observer，是当上滑子页面上滑后，上方会出现可以左右切换怪兽的Widget设定。
                Observer(builder: (_) {
                  return AppBar(
                    // // 第4个stack
                    title: AnimatedOpacity(
                      // 这title我感觉没有实际意义。没有任何作用?
                      duration: Duration(milliseconds: 30),
                      opacity: _tennisPlayerDetailsStore.opacityTitleAppbar,
                      // 这边opacity若是1，则一旦上滑，AppBarNavigationWidget就会明显的显示。
                      // 这边opacity若是opacityTitleAppbar，则一旦上滑，AppBarNavigationWidget就会半透明的显示。
                      child: Visibility(
                        child: AppBarNavigationWidgetForTennisPlayer(),
                        // AppBarNavigationWidget，是当上滑子页面(基础数值)出现到顶端时，
                        // 上方会出现可以左右切换怪兽的控制区域。
                        visible:
                            _tennisPlayerDetailsStore.opacityTitleAppbar > 0,
                      ),
                    ),
                    backgroundColor: Colors.transparent, //表示appBar那一条空间没有颜色。
                    shadowColor: Colors.transparent, //表示appBar那一条空间没有颜色。
                    leading: IconButton(
                      // AppBar的Leading，是最左边的图标，即返回箭头。
                      icon: Icon(Icons.arrow_back,
                          color: AppTheme.getColors(context)
                              .tennisPlayerDetailsTitleColor),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    actions: [
                      if (_tennisPlayerStore
                          .isFavorite(_tennisPlayerStore.tennisPlayer!.number))
                        // 第一个if，_pokemonStore前面没有!，意思是"若是我的最爱"。
                        IconButton(
                          icon: Icon(
                            Icons.favorite,
                            color: AppTheme.getColors(context)
                                .tennisPlayerDetailsTitleColor,
                          ),
                          onPressed: () {
                            _tennisPlayerStore.removeFavoriteTennisPlayer(
                                _tennisPlayerStore.tennisPlayer!.number);

                            BotToast.showText(
                                text:
                                    "${_tennisPlayerStore.tennisPlayer!.name} was removed from favorites");
                          },
                        ),
                      if (!_tennisPlayerStore
                          .isFavorite(_tennisPlayerStore.tennisPlayer!.number))
                        // 第二个if，_pokemonStore前面有!，意思是"若不是我的最爱"。
                        IconButton(
                          icon: Icon(Icons.favorite_border,
                              color: AppTheme.getColors(context)
                                  .tennisPlayerDetailsTitleColor),
                          onPressed: () {
                            _tennisPlayerStore.addFavoriteTennisPlayer(
                                _tennisPlayerStore.tennisPlayer!.number);
                            BotToast.showText(
                                text:
                                    "${_tennisPlayerStore.tennisPlayer!.name} was favorited");
                          },
                        ),
                      IconButton(
                        // 这边的onPressed，是没有任何作用的! 他并不会 open 任何 endDrawer。
                        // Make sure that the IconButton is wrapped within a Scaffold
                        // widget or is a descendant of a Scaffold widget.
                        // Otherwise, the Scaffold.of(context) call will throw an error.
                        onPressed: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                        // 这边的IconButton是右上方的昼夜切换图标。
                        icon: ThemeSwitcher(builder: (context) {
                          return InkWell(
                            onTap: () async {
                              ThemeSwitcher.of(context).changeTheme(
                                  theme: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? darkTheme
                                      : lightTheme);
                              // 这边SharedPreferences有点玄，删掉，我看日夜切换也正常。
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              // 这是记忆我们所选的昼夜模式。就算在详细页面切换昼夜，跳回者页面依然保持新的昼夜设定。
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
                                    .tennisPlayerDetailsTitleColor),
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
                                  color: AppTheme.colors.tennisPlayerItem(
                                      _tennisPlayerStore
                                          .tennisPlayer!.types[0]),
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
                                      opacity: _tennisPlayerDetailsStore
                                          .opacityTennisPlayer,
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
                                    opacity: _tennisPlayerDetailsStore
                                        .opacityTennisPlayer,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 30),
                                      child: Container(
                                        height: 220,
                                        child: Stack(
                                          children: [
                                            TennisPlayerPagerWidget(
                                              pageController: _pageController,
                                              tennisPlayerDetailStore:
                                                  _tennisPlayerDetailsStore,
                                              isFavorite:
                                                  widget.isFavoriteTennisPlayer,
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
                                  opacity: _tennisPlayerDetailsStore
                                      .opacityTennisPlayer,
                                  child: TennisPlayerTitleInfoWidget(),
                                  // PokemonTitleInfoWidget 是详情页面中，怪兽上半部名称、类别、编号的基本信息。
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 下面这Flexible，只是拿来叠高的，因为上滑页面占了画面一半，所以要把怪物图片
                  // 的部份稍微垫高。若把flex改成2，会发现怪物图片上升了。
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
              // 第2个stack，即Container，是四个(about/base stats...)的页面。
              Container(
                width: size.width,
                height: size.height,
                // 宽度要是改成100，会发现上滑页面变成靠左侧的细细一条。
                // 下面的PokemonMobilePanelWidget，是具体四个怪兽详细资料的子页面。
                // 其实这个container的高度是整个body，即涵盖怪兽图片。只是上滑页面有设定只露出一半。
                child: TennisPlayerMobilePanelWidget(
                  listener: (position) {
                    _tennisPlayerDetailsStore.setProgress(position, 0.0, 0.65);
                    // 这setProgress，是定义 "_progress 、 _opacityTitleAppbar 、 _opacityPokemon" 用的。
                    // 详见 pokemon_details_store.dart。
                    // 若 position = 0，则下方上滑子页面一但上滑，上面的怪兽名称、图标不会淡出、永远显示。
                    // 若 position = 1，则下方上滑子页面一但上滑，上面的怪兽名称、图标立刻不见。
                    // 若 position = position，则下方上滑子页面一但上滑，上面的怪兽名称、图标缓缓淡出。

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
