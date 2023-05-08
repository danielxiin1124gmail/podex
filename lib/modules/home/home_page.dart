import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:pokedex/modules/home/home_page_store.dart';
import 'package:pokedex/modules/home/widgets/animated_fab/animated_float_action_button.dart';
import 'package:pokedex/modules/home/widgets/home_panel/home_panel.dart';

import 'package:pokedex/modules/items/items_page.dart';
import 'package:pokedex/modules/tennisItems/tennisItems_page.dart';

import 'package:pokedex/modules/pokemon_grid/pokemon_grid_page.dart';
import 'package:pokedex/modules/tennisPlayer_grid/tennisPlayer_grid_page.dart';

import 'package:pokedex/shared/models/pokemon.dart';
import 'package:pokedex/shared/models/tennisPlayer.dart';

import 'package:pokedex/shared/stores/item_store/item_store.dart';
import 'package:pokedex/shared/stores/tennisItem_store/tennisItem_store.dart';

import 'package:pokedex/shared/stores/pokemon_store/pokemon_store.dart';
import 'package:pokedex/shared/stores/tennisPlayer_store/tennisPlayer_store.dart';

import 'package:pokedex/shared/ui/canvas/white_pokeball_canvas.dart';
import 'package:pokedex/shared/ui/widgets/app_bar.dart';
import 'package:pokedex/shared/ui/widgets/drawer_menu/drawer_menu.dart';
import 'package:pokedex/shared/utils/app_constants.dart';
import 'package:pokedex/shared/utils/converters.dart';
import 'package:pokedex/theme/app_theme.dart';
import 'package:pokedex/theme/light/light_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../theme/dark/dark_theme.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  // AnimationController 里面有 Ticker objects，而 TickerProviderStateMixin 可提供 Ticker objects。
  late AnimationController _backgroundAnimationController;
  // 这是当点击 FAB(float action button) 时，出现的全屏黑色半透明一层东西。
  late Animation<double> _blackBackgroundOpacityAnimation;
  // 这是当点击 FAB(float action button) 时，出现的全屏黑色半透明一层东西。
  late AnimationController _fabAnimationRotationController;
  // 这个不是FAB点击时会旋转，而是载入首页时FAB从右侧转出来的动画。
  late AnimationController _fabAnimationOpenController;
  // 这个是FAB点击时，圆形FAB按钮会旋转+菜单会展开。
  late Animation<double> _fabRotateAnimation;
  late Animation<double> _fabSizeAnimation;

  late PokemonStore _pokemonStore; // 他负责怪兽资料 fetching
  late TennisPlayerStore _tennisPlayerStore;

  late ItemStore _itemStore; // 他负责物品资料 fetching
  late TennisItemStore _tennisItemStore; // 我加的
  late HomePageStore _homeStore; // 他负责分辨现在是怪兽或物品清单页面，然后是否隐藏FAB。
  late PanelController _panelController; // 这是很长被使用的Package，上滑式子页面。

  late List<ReactionDisposer> reactionDisposer = [];
  // 好像是有些功能需要 dispose，我们创建这个 list 来集合他们。

  @override
  void initState() {
    super.initState();

    _pokemonStore = GetIt.instance<PokemonStore>();
    _tennisPlayerStore = GetIt.instance<TennisPlayerStore>();
    _itemStore = GetIt.instance<ItemStore>();
    _tennisItemStore = GetIt.instance<TennisItemStore>();
    _homeStore = GetIt.instance<HomePageStore>();
    _panelController = PanelController();

    _backgroundAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
    _blackBackgroundOpacityAnimation =
        Tween(begin: 0.0, end: 1.0).animate(_backgroundAnimationController);
    // Tween 的意思类似于，在 Duration(milliseconds: 250) 内，从没动画(即0)执行到完整动画(即1)。
    // 把1改成0.2，会发现比较没那么暗；把它改成5、10，却也没深到看不见背景。可能有效最大值是1。

    _fabAnimationRotationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
      // 这个不是FAB点击时会旋转，而是载入首页时FAB从右侧转出来的动画。花 400ms 转出来。
    );

    _fabAnimationOpenController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
      // 这个是FAB点击时，圆形FAB按钮会旋转+菜单会展开。花费 250ms。
    );

    _fabRotateAnimation = Tween(begin: 180.0, end: 0.0).animate(
      CurvedAnimation(
          curve: Curves.easeOut, parent: _fabAnimationRotationController),
      // CurvedAnimation 的 Curves.easeOut，是让FAB从右侧划出来；改成bounceIn，会跳出来。
    );

    _fabSizeAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.4), weight: 80.0),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 20.0),
    ]).animate(_fabAnimationRotationController);
    // 这是右下角菜单弹出动画。如果两个1.4都调成5.0，会发现圆形菜单一开始会很大然后从画面中间出来再缩到右下角。
    // 如果end:1.0改成0.0，动画结束时圆形菜单会不见。更改那个80/20看不出区别。

    //下面是隐藏/显示FAB。
    reactionDisposer.add(
      reaction((_) => _homeStore.isFilterOpen, (_) {
        // 电脑如何侦测isFilterOpen，得看g.dart。当前没有很懂。
        if (_homeStore.isFilterOpen) {
          _panelController.open();
          // 要是去掉_panelController，所有上滑子介面都会失效；我的最爱无法显示、搜索无法显示但会弹出键盘。
          _homeStore.showBackgroundBlack(); // 这我感觉有没有，没差，看不出来区别。
          _homeStore.hideFloatActionButton(); // 这是在各种filter介面上，隐藏FAB。
        } else {
          _panelController.close();
          _homeStore.hideBackgroundBlack();
          _homeStore.showFloatActionButton();
          // 若无showFloatActionButton，一开始载入时依然有FAB，但是一旦点了filter，返回后，FAB会消失。
        }
      }),
    );

    //下面是隐藏/显示 点击FAB所弹出的一层半透明黑色薄膜。
    reactionDisposer.add(
      reaction((_) => _homeStore.isBackgroundBlack, (_) {
        if (_homeStore.isBackgroundBlack) {
          _backgroundAnimationController.forward();
        } else {
          _backgroundAnimationController.reverse();
        }
      }),
    );

    //下面是隐藏/显示 点击FAB之前，从右侧滑入或滑出的动画。
    reactionDisposer.add(
      reaction((_) => _homeStore.isFabVisible, (_) {
        if (_homeStore.isFabVisible) {
          _fabAnimationRotationController.forward();
        } else {
          _fabAnimationRotationController.reverse();
        }
      }),
    );

    //如果没有下面的，依然会导致首页的FAB出不来。
    _fabAnimationRotationController.forward();
  }

  //如下面的，虽然整段注掉不会发现哪里出现错误，但用意是在释放资源，避免memory占用过高。
  @override
  void dispose() {
    reactionDisposer.forEach((disposer) => disposer());

    super.dispose();
  }

  String _getSearchFabButtonText(String? filter) {
    // 其实我没有很明白 filter.trim().isNotEmpty 的用意。去掉搜索功能看起来也正常。
    // 这里功能是，search子菜单上，若已有输入文字，例如005，则显示 "Search: 005"。
    // 要划掉输入框之后，按下FAB，才能发现。
    if (filter != null && filter.trim().isNotEmpty) {
      return "Search: $filter";
    } else {
      return "Search";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      // ThemeSwitchingArea / animated_theme_switcher.dart 意义是快速切换白天/黑夜/其他色彩模式。
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          endDrawer: Drawer(
            child: DrawerMenuWidget(),
            // endDrawer 就是在右侧的抽屉。如果只是"Drawer"，则是预设的左侧抽屉。
            // endDrawer有个child，名为DrawerMenuWidget，这才是真正抽屉画面所在。
          ),
          body: Stack(
            children: [
              // 第一个 children，即SafeArea，意义是制造出 AppBarWidget、怪兽、物品GridView。
              SafeArea(
                bottom: false,
                child: CustomScrollView(
                  slivers: [
                    // Silvers 意义在于上方appBar可以因上滑而缩放。
                    // Examples of sliver widgets are SliverAppBar, SliverList, SliverGrid, and SliverPadding.
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        // 这是上半部份slivers区域，即整个appBar的左右两遍 horizontal padding。
                        // 包含 Tennis Items + 乌龟 整个 appBar区域的左右间隔。
                      ),
                      sliver: Observer(
                        builder: (_) => AppBarWidget(
                          title: _homeStore.page.description,
                          lottiePath: AppConstants.squirtleLottie,
                        ),
                      ),
                    ),

                    // 此处"算是"定义首页是谁。
                    Observer(
                      builder: (_) {
                        // 这里是说当 _homeStore.page = 某人，则 return 某页面。
                        // 那就竟 _homeStore.page 在哪定义? 在 home_page_store.dart里面，
                        // 的这里: @observable --> HomePageType _page = HomePageType.POKEMON_GRID;
                        switch (_homeStore.page) {
                          case HomePageType.POKEMON_GRID:
                            return PokemonGridPage();
                          case HomePageType.ITENS:
                            return ItemsPage();
                          case HomePageType.TENNIS_PLAYER_GRID:
                            return TennisPlayerGridPage();
                          case HomePageType.TENNIS_ITEMS:
                            return TennisItemsPage();
                          default:
                            return PokemonGridPage();
                        }
                      },
                    ),
                  ],
                ),
              ),
              Stack(
                // 这边意义在于，持续显示FAB。虽然说若下方删除，在一开始跑app依然有FAB，
                // 但是一旦点了某个filter 然后再返回主页面，会发现FAB不见了。所以以下是确保FAB会持续显示。
                children: [
                  Observer(builder: (_) {
                    if (_homeStore.isBackgroundBlack) {
                      return AnimatedBuilder(
                        animation: _fabAnimationRotationController,
                        // 我感觉所谓黑幕的出场动画，其实看不出来，都黑的一片，看不出来他有没有转。
                        // 所以就算改成其他Controller，其实也正常、看不出区别。
                        builder: (_, child) => FadeTransition(
                            opacity: _blackBackgroundOpacityAnimation,
                            child: child),
                        // builder 意义在于，只是制造出当按下 FAB时，所产生的全屏半透明黑幕。
                        child: GestureDetector(
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.black87,
                            // 这里 Container 是当按下 FAB时，所产生的全屏半透明黑幕。
                          ),
                          onTap: () {
                            if (_homeStore.isBackgroundBlack) {
                              _homeStore.hideBackgroundBlack();
                              _fabAnimationOpenController.reverse();
                              _panelController.close();
                            }
                          },
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
                  // HomePanelWidget 是 FAB的各种Filter的上滑式子画面。
                  HomePanelWidget(
                    panelController: _panelController,
                    homePageStore: _homeStore,
                    pokemonStore: _pokemonStore,
                    tennisPlayerStore: _tennisPlayerStore,
                    itemStore: _itemStore,
                    tennisItemStore: _tennisItemStore,
                  )
                ],
              ),
              ThemeSwitcher(builder: (context) {
                return Observer(
                  builder: (_) {
                    return AnimatedBuilder(
                      animation: _fabAnimationRotationController,
                      builder: (_, child) => Transform(
                        alignment: Alignment.bottomRight,
                        transform: Matrix4.rotationZ(
                            getRadiansFromDegree(_fabRotateAnimation.value))
                          ..scale(_fabSizeAnimation.value),
                        child: child,
                      ),
                      child: AnimatedFloatActionButtonWidget(
                        homeStore: _homeStore,
                        openAnimationController: _fabAnimationOpenController,
                        buttons: [
                          CircularFabTextButton(
                            text:
                                Theme.of(context).brightness == Brightness.light
                                    ? "Moon Theme"
                                    : "Sun Theme",
                            icon: SizedBox(
                              child: Icon(
                                Theme.of(context).brightness == Brightness.light
                                    ? Icons.dark_mode
                                    : Icons.light_mode,
                                color: AppTheme.getColors(context)
                                    .floatActionButton,
                              ),
                            ),
                            color: Theme.of(context).colorScheme.background,
                            onClick: () async {
                              ThemeSwitcher.of(context).changeTheme(
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
                          ),
                          //----------------------------------------------//
                          // 下面是，如果当前页面是怪兽grid，则FAB要增加"Search"子菜单。
                          if (_homeStore.page == HomePageType.POKEMON_GRID)
                            CircularFabTextButton(
                              text: _getSearchFabButtonText(_pokemonStore
                                  .pokemonFilter.pokemonNameNumberFilter),
                              icon: SizedBox(
                                child: Icon(
                                  Icons.search,
                                  color: AppTheme.getColors(context)
                                      .floatActionButton,
                                ),
                              ),
                              color: Theme.of(context).colorScheme.background,
                              onClick: () {
                                _fabAnimationOpenController.reverse();
                                _homeStore.setPanelType(
                                    PanelType.FILTER_POKEMON_NAME_NUMBER);
                                _homeStore.openFilter();
                                _homeStore.hideBackgroundBlack();
                              },
                            ),
                          // 下面是，如果当前页面是 tennis Player grid，则FAB要增加"Search"子菜单。
                          if (_homeStore.page ==
                              HomePageType.TENNIS_PLAYER_GRID)
                            CircularFabTextButton(
                              text: _getSearchFabButtonText(_tennisPlayerStore
                                  .tennisPlayerFilter
                                  .tennisPlayerNameNumberFilter),
                              icon: SizedBox(
                                child: Icon(
                                  Icons.search,
                                  color: AppTheme.getColors(context)
                                      .floatActionButton,
                                ),
                              ),
                              color: Theme.of(context).colorScheme.background,
                              onClick: () {
                                _fabAnimationOpenController.reverse();
                                _homeStore.setPanelType(
                                    PanelType.FILTER_TENNIS_PLAYER_NAME_NUMBER);
                                _homeStore.openFilter();
                                _homeStore.hideBackgroundBlack();
                              },
                            ),
                          // 下面是，如果当前页面是物品页，则FAB要增加"Search"子菜单。
                          if (_homeStore.page == HomePageType.ITENS)
                            CircularFabTextButton(
                              text: _getSearchFabButtonText(_itemStore.filter),
                              icon: SizedBox(
                                child: Icon(
                                  Icons.search,
                                  color: AppTheme.getColors(context)
                                      .floatActionButton,
                                ),
                              ),
                              color: Theme.of(context).colorScheme.background,
                              onClick: () {
                                _fabAnimationOpenController.reverse();
                                _homeStore.setPanelType(PanelType.FILTER_ITEMS);
                                _homeStore.openFilter();
                                _homeStore.hideBackgroundBlack();
                              },
                            ),
                          // 下面是，如果当前页面是tennisItems，则FAB要增加"Search"子菜单。
                          if (_homeStore.page == HomePageType.TENNIS_ITEMS)
                            CircularFabTextButton(
                              text: _getSearchFabButtonText(
                                  _tennisItemStore.filter),
                              icon: SizedBox(
                                child: Icon(
                                  Icons.search,
                                  color: AppTheme.getColors(context)
                                      .floatActionButton,
                                ),
                              ),
                              color: Theme.of(context).colorScheme.background,
                              onClick: () {
                                _fabAnimationOpenController.reverse();
                                _homeStore.setPanelType(PanelType
                                    .FILTER_TENNIS_ITEMS); // 这里记得改，电脑才知道你的panelType是啥。
                                _homeStore.openFilter();
                                _homeStore.hideBackgroundBlack();
                              },
                            ),
                          //----------------------------------------------//
                          // 下面是，如果当前页面是怪兽grid，则FAB要增加"All Generations"子菜单。
                          if (_homeStore.page == HomePageType.POKEMON_GRID)
                            CircularFabTextButton(
                              text: _pokemonStore
                                          .pokemonFilter.generationFilter ==
                                      null
                                  ? "All Generations"
                                  : Generation
                                      .values[_pokemonStore.pokemonFilter
                                          .generationFilter!.index]
                                      .description,
                              icon: CustomPaint(
                                size: Size(
                                    20, (20 * 1.0040160642570282).toDouble()),
                                painter: PokeballLogoPainter(
                                  color: AppTheme.getColors(context)
                                      .floatActionButton,
                                ),
                              ),
                              color: Theme.of(context).colorScheme.background,
                              onClick: () {
                                _fabAnimationOpenController.reverse();
                                _homeStore.setPanelType(
                                    PanelType.FILTER_POKEMON_GENERATION);
                                _homeStore.openFilter();
                              },
                            ),
                          // 下面是，如果当前页面是怪兽grid，则FAB要增加"All Types"子菜单。
                          if (_homeStore.page == HomePageType.POKEMON_GRID)
                            CircularFabTextButton(
                              text:
                                  _pokemonStore.pokemonFilter.typeFilter == null
                                      ? "All Types"
                                      : _pokemonStore.pokemonFilter.typeFilter!,
                              icon: CustomPaint(
                                size: Size(
                                    20, (20 * 1.0040160642570282).toDouble()),
                                painter: PokeballLogoPainter(
                                  color: AppTheme.getColors(context)
                                      .floatActionButton,
                                ),
                              ),
                              color: Theme.of(context).colorScheme.background,
                              onClick: () {
                                _fabAnimationOpenController.reverse();
                                _homeStore.setPanelType(
                                    PanelType.FILTER_POKEMON_TYPE);
                                _homeStore.openFilter();
                              },
                            ),
                          // 下面是，如果当前页面是 Tennis Player grid，则FAB要增加"All Types"子菜单。
                          if (_homeStore.page ==
                              HomePageType.TENNIS_PLAYER_GRID)
                            CircularFabTextButton(
                              text: _tennisPlayerStore
                                          .tennisPlayerFilter.typeFilter ==
                                      null
                                  ? "Player Types"
                                  : _tennisPlayerStore
                                      .tennisPlayerFilter.typeFilter!,
                              icon: CustomPaint(
                                size: Size(
                                    20, (20 * 1.0040160642570282).toDouble()),
                                painter: PokeballLogoPainter(
                                  color: AppTheme.getColors(context)
                                      .floatActionButton,
                                ),
                              ),
                              color: Theme.of(context).colorScheme.background,
                              onClick: () {
                                _fabAnimationOpenController.reverse();
                                _homeStore.setPanelType(
                                    PanelType.FILTER_TENNIS_PLAYER_TYPE);
                                _homeStore.openFilter();
                              },
                            ),

                          // 下面是，如果当前页面是 Tennis Player grid，则FAB要增加"Style"子菜单。
                          if (_homeStore.page ==
                              HomePageType.TENNIS_PLAYER_GRID)
                            CircularFabTextButton(
                              text: _tennisPlayerStore
                                          .tennisPlayerFilter.styleFilter ==
                                      null
                                  ? "Styles"
                                  : _tennisPlayerStore
                                      .tennisPlayerFilter.styleFilter!,
                              icon: CustomPaint(
                                size: Size(
                                    20, (20 * 1.0040160642570282).toDouble()),
                                painter: PokeballLogoPainter(
                                  color: AppTheme.getColors(context)
                                      .floatActionButton,
                                ),
                              ),
                              color: Theme.of(context).colorScheme.background,
                              onClick: () {
                                _fabAnimationOpenController.reverse();
                                _homeStore.setPanelType(
                                    PanelType.FILTER_TENNIS_PLAYER_STYLE);
                                _homeStore.openFilter();
                              },
                            ),

                          // 下面是，如果当前页面是 Tennis Player grid，则FAB要增加"Country"子菜单。
                          if (_homeStore.page ==
                              HomePageType.TENNIS_PLAYER_GRID)
                            CircularFabTextButton(
                              text: _tennisPlayerStore
                                          .tennisPlayerFilter.countryFilter ==
                                      null
                                  ? "Countrys"
                                  : _tennisPlayerStore
                                      .tennisPlayerFilter.countryFilter!,
                              icon: CustomPaint(
                                size: Size(
                                    20, (20 * 1.0040160642570282).toDouble()),
                                painter: PokeballLogoPainter(
                                  color: AppTheme.getColors(context)
                                      .floatActionButton,
                                ),
                              ),
                              color: Theme.of(context).colorScheme.background,
                              onClick: () {
                                _fabAnimationOpenController.reverse();
                                _homeStore.setPanelType(
                                    PanelType.FILTER_TENNIS_PLAYER_COUNTRY);
                                _homeStore.openFilter();
                              },
                            ),

                          // 下面是，如果当前页面是 Tennis Player grid，则FAB要增加"RightOrLeft"子菜单。
                          if (_homeStore.page ==
                              HomePageType.TENNIS_PLAYER_GRID)
                            CircularFabTextButton(
                              text: _tennisPlayerStore.tennisPlayerFilter
                                          .rightOrLeftFilter ==
                                      null
                                  ? "Right ro Left Handed"
                                  : _tennisPlayerStore
                                      .tennisPlayerFilter.rightOrLeftFilter!,
                              icon: CustomPaint(
                                size: Size(
                                    20, (20 * 1.0040160642570282).toDouble()),
                                painter: PokeballLogoPainter(
                                  color: AppTheme.getColors(context)
                                      .floatActionButton,
                                ),
                              ),
                              color: Theme.of(context).colorScheme.background,
                              onClick: () {
                                _fabAnimationOpenController.reverse();
                                _homeStore.setPanelType(PanelType
                                    .FILTER_TENNIS_PLAYER_RIGHT_OR_LEFT);
                                _homeStore.openFilter();
                              },
                            ),

                          // 下面是，如果当前页面是 Tennis Player grid，则FAB要增加"Backhand Style"子菜单。
                          if (_homeStore.page ==
                              HomePageType.TENNIS_PLAYER_GRID)
                            CircularFabTextButton(
                              text: _tennisPlayerStore.tennisPlayerFilter
                                          .backhandStyleFilter ==
                                      null
                                  ? "Backhand Style"
                                  : _tennisPlayerStore
                                      .tennisPlayerFilter.backhandStyleFilter!,
                              icon: CustomPaint(
                                size: Size(
                                    20, (20 * 1.0040160642570282).toDouble()),
                                painter: PokeballLogoPainter(
                                  color: AppTheme.getColors(context)
                                      .floatActionButton,
                                ),
                              ),
                              color: Theme.of(context).colorScheme.background,
                              onClick: () {
                                _fabAnimationOpenController.reverse();
                                _homeStore.setPanelType(PanelType
                                    .FILTER_TENNIS_PLAYER_BACKHAND_STYLE);
                                _homeStore.openFilter();
                              },
                            ),

                          //----------------------------------------------//
                          // 下面是，如果当前页面是怪兽grid，则FAB要增加"我的最爱"子菜单。
                          if (_homeStore.page == HomePageType.POKEMON_GRID)
                            CircularFabTextButton(
                              text: "Favorite Pokemons",
                              icon: Icon(
                                Icons.favorite,
                                color: AppTheme.getColors(context)
                                    .floatActionButton,
                              ),
                              color: Theme.of(context).colorScheme.background,
                              onClick: () {
                                _fabAnimationOpenController.reverse();
                                _homeStore
                                    .setPanelType(PanelType.FAVORITES_POKEMONS);
                                _homeStore.openFilter();
                              },
                            ),
                          // 下面是，如果当前页面是怪兽tennis player grid，则FAB要增加"我的最爱"子菜单。
                          if (_homeStore.page ==
                              HomePageType.TENNIS_PLAYER_GRID)
                            CircularFabTextButton(
                              text: "Favorite Tennis Players",
                              icon: Icon(
                                Icons.favorite,
                                color: AppTheme.getColors(context)
                                    .floatActionButton,
                              ),
                              color: Theme.of(context).colorScheme.background,
                              onClick: () {
                                _fabAnimationOpenController.reverse();
                                _homeStore.setPanelType(
                                    PanelType.FAVORITES_TENNIS_PLAYERS);
                                _homeStore.openFilter();
                              },
                            ),
                        ],
                      ),
                    );
                  },
                );
              })
            ],
          ),
        );
      }),
    );
  }
}
