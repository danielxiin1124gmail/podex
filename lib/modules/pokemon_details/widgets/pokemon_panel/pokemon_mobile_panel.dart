import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pokedex/modules/pokemon_details/widgets/pokemon_panel/pages/about/about_page.dart';
import 'package:pokedex/modules/pokemon_details/widgets/pokemon_panel/pages/base_stats/base_stats_page.dart';
import 'package:pokedex/modules/pokemon_details/widgets/pokemon_panel/pages/evolution/evolution_page.dart';
import 'package:pokedex/modules/pokemon_details/widgets/pokemon_panel/pages/moves/moves_page.dart';
import 'package:pokedex/shared/ui/enums/device_screen_type.dart';
import 'package:pokedex/theme/app_theme.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

double getDetailsPanelsPadding(Size size) {
  double horizontalPadding = 0;

  if (size.width > 1200) {
    horizontalPadding = size.width * 0.28;
  } else if (size.width > 900) {
    horizontalPadding = size.width * 0.2;
  } else if (size.width > 600) {
    horizontalPadding = 28;
  } else {
    horizontalPadding = 28;
  }

  return horizontalPadding;
}

class PokemonMobilePanelWidget extends StatefulWidget {
  final Function(double position) listener;
  // 有这Function，是因为之后要用到onPanelSlide，这属性就是得用 Function。

  const PokemonMobilePanelWidget({
    Key? key,
    required this.listener,
  }) : super(key: key);

  @override
  _PokemonMobilePanelWidgetState createState() =>
      _PokemonMobilePanelWidgetState();
}

class _PokemonMobilePanelWidgetState extends State<PokemonMobilePanelWidget>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<PokemonMobilePanelWidget> {
  // 上面这AutomaticKeepAlive，用于当关闭了页面、widget后，若再开启，仍能保持state。具体作用待研究。
  late TabController _tabController;
  late PanelController _panelController;
  late ScrollController _aboutScrollController;
  late ScrollController _baseStatsController;
  late ScrollController _evolutionController;
  late ScrollController _movesController;

  @override
  bool get wantKeepAlive => true;
  // 现在尚未明白改成false有啥区别。

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: 4); // 这4乱改，没区别。
    _panelController = PanelController();
    _aboutScrollController = ScrollController();
    _baseStatsController = ScrollController();
    _evolutionController = ScrollController();
    _movesController = ScrollController();
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  void onScroll(UserScrollNotification scrollInfo) {
    // 下面貌似是当使用者上下滑动时，要开或关叫panelController的东西。但//掉，在安卓上没啥区别。
    // 在Web上没测试。
    if (kIsWeb ||
        io.Platform.isWindows ||
        io.Platform.isLinux ||
        io.Platform.isMacOS) {
      if (scrollInfo.metrics.pixels > 0) {
        // metrics.pixels > 0 意义是，检查用户有没有 scroll down。
        if (!_panelController.isPanelOpen) {
          _panelController.open();
        }
      }

      if (scrollInfo.metrics.pixels == 0) {
        if (_panelController.isPanelOpen) {
          _panelController.close();
        }
      }
    }
  }

  ScrollController? setScrollControllerByPlatform(
      BuildContext context, ScrollController scrollController) {
    return (kIsWeb &&
                getDeviceScreenType(context) != DeviceScreenType.CELLPHONE) ||
            (!kIsWeb && !io.Platform.isAndroid && !io.Platform.isIOS)
        ? scrollController
        : null;
    // If the current platform is not Android or iOS, or if the device screen type
    // is not a tablet or desktop on the web platform, then the function returns
    // null which means that no scroll controller is used. Otherwise, the function
    // returns the provided scrollController.
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // 好像一般这里没有 super ?

    final TextTheme textTheme = Theme.of(context).textTheme;

    return SlidingUpPanel(
      maxHeight: MediaQuery.of(context).size.height * 1,
      minHeight: MediaQuery.of(context).size.height * 0.50,
      parallaxEnabled: true, // 这是所谓Stack且上滑时，两层stack是否相对运动的东西。
      parallaxOffset: 0.5,
      controller: _panelController,
      color: Theme.of(context).colorScheme.background,
      panelBuilder: (scrollController) {
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              color: Theme.of(context).colorScheme.background,
            ),
            child: NestedScrollView(
              // NestedScrollView 就是在上滑子页面中，还有侧滑子菜单的功能。
              controller: scrollController,
              headerSliverBuilder: (context, value) {
                return [
                  SliverAppBar(
                    // 这大约就是 about/base/evolution那条的空间。大约而已，有点padding差距。
                    leading: Container(),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    pinned: true, // 改成false，可以隐藏about/base/evolution那条。
                    centerTitle: true,
                    flexibleSpace: Stack(
                      children: [
                        // 下面的 Container 是真正的 about/base/evolution那条。
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          child: TabBar(
                            unselectedLabelColor:
                                AppTheme.getColors(context).pokemonTabTitle,
                            // unselectedLabelColor，改成 Colors.red 无作用。
                            labelColor: AppTheme.getColors(context)
                                .selectPokemonTabTitle,
                            // labelColor，改成 Colors.red 无作用。
                            unselectedLabelStyle: textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                            labelStyle: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: null,
                              // 改 color也没作用。估计是在某处代码，颜色会被覆盖、重新定义?
                            ),
                            indicatorColor:
                                AppTheme.getColors(context).tabIndicator,
                            // indicatorColor就是about/base/evolution那条的底线颜色。
                            controller: _tabController,
                            tabs: [
                              Tab(
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child:
                                      Text("About", style: textTheme.bodyLarge),
                                ),
                              ),
                              Tab(
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text("Base Stats",
                                      style: textTheme.bodyLarge),
                                ),
                              ),
                              Tab(
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text("Evolution",
                                      style: textTheme.bodyLarge),
                                ),
                              ),
                              Tab(
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child:
                                      Text("Moves", style: textTheme.bodyLarge),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ];
              },
              body: Padding(
                padding: EdgeInsets.only(top: 20),
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // 如果没有下面第一个Child，NotificationListener，about/base/evolution那条
                    // 会错乱，乱显示。
                    NotificationListener<UserScrollNotification>(
                      child: SingleChildScrollView(
                        controller: setScrollControllerByPlatform(
                            context, _aboutScrollController),
                        child: const AboutPage(),
                      ),
                      onNotification: (UserScrollNotification scrollInfo) {
                        onScroll(scrollInfo);

                        return true;
                      },
                    ),
                    // 下面是 base status 那页的相关设定
                    NotificationListener<UserScrollNotification>(
                      child: SingleChildScrollView(
                        child: const BaseStatsPage(),
                        controller: setScrollControllerByPlatform(
                            context, _baseStatsController),
                      ),
                      onNotification: (UserScrollNotification scrollInfo) {
                        onScroll(scrollInfo);

                        return true;
                      },
                    ),
                    // 下面是 EvolutionPage 那页的相关设定，我没细看。
                    NotificationListener<UserScrollNotification>(
                      child: SingleChildScrollView(
                        child: const EvolutionPage(),
                        controller: setScrollControllerByPlatform(
                            context, _evolutionController),
                      ),
                      onNotification: (UserScrollNotification scrollInfo) {
                        onScroll(scrollInfo);

                        return true;
                      },
                    ),
                    // 下面是 MovesPage 那页的相关设定，可学习他的table，战绩用的到。
                    NotificationListener<UserScrollNotification>(
                      child: SingleChildScrollView(
                        child: const MovesPage(),
                        controller: setScrollControllerByPlatform(
                            context, _movesController),
                      ),
                      onNotification: (UserScrollNotification scrollInfo) {
                        onScroll(scrollInfo);

                        return true;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      // 下面是上滑页面左右上角的圆角，要滑动才看的到，因为至中时，有另一个灰色帽子盖住。
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      onPanelSlide: widget.listener,
      boxShadow: null,
    );
  }
}
